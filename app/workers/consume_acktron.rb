# app/workers/hard_worker.rb
class ConsumeAcktron
  include Sidekiq::Worker

  def perform(params)
    select_name = ['vin_make','vin_year','vin_model','vin_engine','vin_special','vin_error']
    field_name = ['make','year','model','engine','system', 'code']

    startindex = Index.where({miner: params['miner'], mode: "start"})
    stopindex = Index.where({miner: params['miner'], mode: "last"})
    currentindex = Index.where({miner: params['miner'], mode: "current"})

    # set the starting location:
    if (currentindex.index.first != nil )
      start = currentindex.first
    else
      start = startindex.first
    end
    stop = stopindex.first

    index = []
    last = []
    index[0] = start.make
    index[1] = start.year
    index[2] = start.model
    index[3] = start.engine
    index[4] = start.system
    index[5] = start.dtc

    last[0] = stop.make
    last[1] = stop.year
    last[2] = stop.model
    last[3] = stop.engine
    last[4] = stop.system
    last[5] = stop.dtc

    application = {}
    codes = []
    id = start.miner

    Watir.always_locate=false
    browser = Watir::Browser.new
    browser.goto params['url']

    consume_select(id, 0, index, last, browser, select_name, field_name, application, params) # start and selector 0, option #1

  end


  def save_dtcs(id, codes, index)
    for code in codes do
      code[:app].delete('system')

      fitment = Fitment.find_or_create_by(code[:app])
      fitment.attributes = code[:app]
      fitment.save
      dtc = Dtc.find_or_create_by(code[:dtc])
      dtc.attributes = code[:dtc]
      dtc.fitments << fitment
      dtc.save
    end
    index = Index.find_or_create_by({miner: id, mode:"current"})
    index.attributes = {miner: id, mode:"current", make: index[0], year: index[1], model: index[2],
                        engine: index[3], system: index[4], dtc: index[5]}
  end

  def consume_select(id, level, index, last, browser, select_name, field_name, application, params)
    _length = browser.select_list(:name => select_name[level]).options.count
    if _length > 5
      _length = 5
    end
    if (level == field_name.length-1)  # bottom level
      codes = []
      for n in 1.._length-1 do
        begin
          option = browser.select_list(:name => 'vin_error').options[n]
          code = option.text
          option.select
          #puts "ix:"+n.to_s+" Application:"+application.to_s+"  Meaning:"+browser.bs[1].text;
          _record =  {app: application, dtc: {code: code, description: browser.bs[1].text, source: params['url'], system: application['system']}}
          codes << _record
          puts "ix:"+n.to_s+_record.to_s
        rescue Exception => e
          puts "ix:"+n.to_s+"  error:"+e.message
        end
      end
      save_dtcs(id, codes, index)

      return true
    elsif (level == 0) # top level
      while index[level] < _length-1 && (index[level] <= last[level] || last[level]<=1) do  # ignore last if it's 1 or 0.
        application[field_name[level]] = browser.select_list(:name => select_name[level]).options[index[level]].text

        browser.select_list(:name => select_name[level]).options[index[level]].select
        level_below_finished = consume_select(id, level+1, index, last, browser, select_name, field_name, application, params)
        if (level_below_finished)
          index[level]+=1
        end
        browser.buttons[1].click # reset at level 0.
      end
    else
      puts "level:"+level.to_s+" index:"+index[level].to_s+"  length:"+_length.to_s
      application[field_name[level]] = browser.select_list(:name => select_name[level]).options[index[level]].text
      browser.select_list(:name => select_name[level]).options[index[level]].select
      level_below_finished = consume_select(id, level+1, index, last, browser, select_name, field_name, application, params)

      if (level_below_finished)
        index[level]+=1
        index[level+1]=1

      end

      return index[level] == _length || (index[level] == last[level] && last[level] > 1) # 0 or 1 for last means do the whole level.
    end
  end

  def fitment_params
    params.require(:fitment).permit(:make, :year, :model, :engine, :dtc_ids => [])
  end
  def dtc_params
    params.require(:dtc).permit(:code, :description, :meaning, :system, :source, :fitment_ids => [])
  end
  def miner_params
    params.require(:index).permit(:miner, :mode, :make, :year, :model,  :engine, :system, :dtc, :miner_ids => [])
  end
end