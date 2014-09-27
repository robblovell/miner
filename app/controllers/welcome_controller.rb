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

  def do_next?(id, number, index)
    return (id % number != index % number)
  end

  def start
    number_to_start = params['how_many'].to_i
    capstone = Capstone.first()
    capstone.index+=1
    capstone.save
    capstone.index-=1
    number_started = 0
    start_make = 1 # assume up to 44 makes.
    start_year = 1 # assume 14 years max.


    Index.find_each(:conditions => "mode='start'") do |index|
      current = Index.first(:conditions => "mode='current' and miner=#{index.miner}")
      last = Index.first(:conditions => "mode='last' and miner=#{index.miner}")
      start_make = last.make
      start_year = last.year
      if (do_next?(current.id, capstone.number, capstone.index)) # skip over ones that this machine doesn't do.
        next
      end
      if (current.make == last.make && current.year == last.year) # done.
        next
      else # start a process.
        ConsumeAcktron.perform_async({miner: current.miner, url: params['url']})
        number_started += 1
        if (number_started == number_to_start)
          break
        end
      end
    end
    last = Index.last
    miner = 0
    if (last)
      miner = last.miner
    end
    start_make = last==nil ? 1:last.make-1 # the last processed make.
    start_year = last==nil ? 0:last.year-1 # the last processed year.
    while (number_started < number_to_start)
      start_year += 1
      if (start_year > 14)
        start_make += 1
        start_year = 1
        if (start_make > 44)
          break # no more records to process.
        end
      end

      miner+=1
      if (do_next?(miner, capstone.number, capstone.index)) # skip over ones that this machine doesn't do.
        next
      end
      Index.create({miner: miner, mode: 'start', make: start_make, year: start_year, model: 1, engine: 1, system: 1, dtc: 1, complete: false})
      Index.create({miner: miner, mode: 'current', make: start_make, year: start_year, model: 1, engine: 1, system: 1, dtc: 1, complete: false})
      Index.create({miner: miner, mode: 'last', make: start_make+1, year: start_year+1, model: 0, engine: 0, system: 0, dtc: 0, complete: false})
      ConsumeAcktron.perform_async({miner: miner, url: params['url']})
      number_started += 1
      if (number_started == number_to_start)
        break
      end
    end

    redirect_to action: 'index'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
