require 'rubygems'

require 'watir'
require 'watir-webdriver'

class WelcomeController < ApplicationController

  # GET /
  def index

  end

  def new
    puts params
    redirect_to action: 'index'
  end

  def create
    puts params
    redirect_to action: 'index'
  end

  #consume_select(0,1)
  #
  #def consume_select(index, location)
  #
  #  if (!browser.selects[index].exists? && browser.bs[1].text.exists?) # at the bottom
  #    puts browser.bs[1].text
  #    reutrn location+1, location == length
  #  else
  #    length = browser.selects[index].options.count
  #    browser.selects[index].options[location].select # select disappears when selected.
  #    # next level appears, but where to start?
  #    finished = false
  #    child_start = 1
  #    while (!finished)
  #      child_start, finished = consume_select(index, child_start)
  #    end
  #    return location+1, location==length
  #  end
  #
  #
  #end

  #def consume_select(index, location)
  #
  #  if (index == 0) # top level.
  #    child_start = 0
  #    for i in start..length-1 do
  #      browser.selects[index].options[i].select # select disappears when selected.
  #      child_start = consume_select(index, child_start) ## the next select, but the previous is gone, so same index.
  #    end
  #  elsif (browser.selects.index(index+1)) # if the next level exists:
  #    consume_select(index+1, 0)
  #  else # at bottom level.
  #    for i in start..length-1 do
  #
  #    end
  #  end
  #  consume_select(index+1, start)
  #  return start, start==length
  #end
  #
  #def consume_select(index, start)
  #  length = browser.selects[index].options.count
  #  if start == length
  #    return start, true # finished = true, my start
  #  end
  #  child_start = 1
  #  for i in start..length-1 do
  #    browser.selects[index].options[i].select # select disappears when selected.
  #    child_start = consume_select(index+1, child_start) # the next select.
  #    if (index == 0)
  #      browser.buttons[1].click # resets to the top.
  #    end
  #  end
  #  return start+1, start == length # if start == length then
  #end

  def consume_select(level, index, browser, select_name, field_name, application, codes )
    _length = browser.select_list(:name => select_name[level]).options.count

    if (level == field_name.length-1)
      for n in 1.._length-1 do
        begin
          option = browser.select_list(:name => 'vin_error').options[n]
          code = option.text
          option.select
          #puts "ix:"+n.to_s+" Application:"+application.to_s+"  Meaning:"+browser.bs[1].text;
          _record =  {app: application, dtc: {code: code, description: browser.bs[1].text, system: application['system']}}
          codes << _record
          puts "ix:"+n.to_s+_record.to_s
        rescue Exception => e
          puts "ix:"+n.to_s+"  error:"+e.message
        end
      end
      return true
    elsif(level == 0)
      while index[level] < _length-1 do
        application[field_name[level]] = browser.select_list(:name => select_name[level]).options[index[level]].text

        browser.select_list(:name => select_name[level]).options[index[level]].select
        level_below_finished = consume_select(level+1, index, browser, select_name, field_name, application, codes )
        if (level_below_finished)
          index[level]+=1
        end
        browser.buttons[1].click # reset at level 0.
      end
    else
      application[field_name[level]] = browser.select_list(:name => select_name[level]).options[index[level]].text
      browser.select_list(:name => select_name[level]).options[index[level]].select
      level_below_finished = consume_select(level+1, index, browser, select_name, field_name, application, codes )

      if (level_below_finished)
        index[level]+=1
      end

      return index[level] == _length
    end
  end

  def calculate
    select_name = ['vin_make','vin_year','vin_model','vin_engine','vin_special','vin_error']
    field_name = ['make','year','model','engine','system', 'code']
    index = [2,1,1,1,1,1]
    application = {}
    codes = []

    Watir.always_locate=false
    browser = Watir::Browser.new
    browser.goto params['url']

    consume_select(0, index, browser, select_name, field_name, application, codes) # start and selector 0, option #1


    #vin_make_length = browser.select_list(:name => 'vin_make').options.count
    #for h in 2..vin_make_length-1 do
    #  make = browser.select_list(:name => 'vin_make').options[h].text
    #
    #  browser.select_list(:name => 'vin_make').options[h].select
    #
    #  vin_year_length = browser.select_list(:name => 'vin_year').options.count
    #  for i in 1..vin_year_length-1 do
    #    year = browser.select_list(:name => 'vin_year').options[i].text
    #    browser.select_list(:name => 'vin_year').options[i].select
    #
    #    vin_model_length = browser.select_list(:name => 'vin_model').options.count
    #    for j in 1..vin_model_length-1 do
    #      model = browser.select_list(:name => 'vin_model').options[j].text
    #      browser.select_list(:name => 'vin_model').options[j].select
    #
    #      vin_engine_length = browser.select_list(:name => 'vin_engine').options.count
    #      for k in 1..vin_engine_length-1 do
    #        engine = browser.select_list(:name => 'vin_engine').options[k].text
    #        browser.select_list(:name => 'vin_engine').options[k].select
    #
    #        vin_system_length = browser.select_list(:name => 'vin_special').options.count
    #        for l in 1..vin_system_length-1 do
    #          browser.select_list(:name => 'vin_special').options[l].select
    #
    #          vin_dtc_length = browser.select_list(:name => 'vin_error').options.count
    #          # get the codes from the dtc selector that has appeared.
    #          #codes = browser.select_list(:name => 'vin_error').options.map{|o| o.text}
    #          #dtc_selector = browser.select_list(:name => 'vin_error').options
    #          #codes = []
    #          #for m in 1..vin_dtc_length
    #          #  codes << dtc_selector[m].text
    #          #end
    #
    #          for n in 1..vin_dtc_length-1 do
    #            begin
    #              option = browser.select_list(:name => 'vin_error').options[n]
    #              code = option.text
    #              option.select
    #              puts "ix:"+n.to_s+" Code:"+code+"  Meaning:"+browser.bs[1].text;
    #              browser.buttons[0].click
    #            rescue Exception => e
    #              puts "ix:"+n.to_s+"  error:"+e.message
    #            end
    #          end
    #          browser.buttons[0].click
    #
    #        end
    #        browser.buttons[0].click
    #
    #      end
    #      browser.buttons[0].click
    #
    #    end
    #    browser.buttons[0].click
    #
    #  end
    #  browser.buttons[0].click
    #
    #end


    #browser.select_list(:name => 'vin_year').options[2].select
    #browser.select_list(:name => 'vin_model').options[2].select
    #browser.select_list(:name => 'vin_engine').options[1].select
    #browser.select_list(:name => 'vin_special').options[1].select
    #browser.select_list(:name => 'vin_error').options[1].select
    #puts browser.bs[1].text
    #browser.buttons[1].click
    #

    puts params
    redirect_to action: 'index'
  end
end
