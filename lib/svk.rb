require 'bundler/setup'
require 'dotenv/load'

require 'date'
require 'httparty'
require 'active_support'
require 'active_support/core_ext'

class Svk
  COUNTRIES = {
    'SN1':nil,
    'SN2':nil,
    'SN3':nil,
    'SN4':nil
  }
  PRODUCTION_TYPES = {
    'VI': :wind,
    'VA': :hydro,
    'SE': :solar,
    'OP': :unspecified,
    'OK': :heat,
    'KK': :nuclear
  }
  class Generation < Svk
    def initialize(country: nil, production_type: 'VI', from: nil, to: nil)
      @country = country
      @production_type = production_type
      @options = {
        PeriodFrom: from.strftime('%m/%d/%Y %H:%M:%S'), # 11/21/2021 00:00:00
        PeriodTo: to.strftime('%m/%d/%Y %H:%M:%S'), # 11/28/2021 00:00:00
        ConstraintAreaId: country,
        ProductionSortId: production_type
      }
      puts @options.inspect
      @r = HTTParty.get(
        'https://mimer.svk.se/ProductionConsumption/DownloadText',
        query: @options,
        #debug_output: $stdout
      )
    end

    def points
      data = CSV.parse(@r.response.body.to_s, col_sep: ';')
      data.shift
      data.pop
      r=[]
      data.each do |row|
        time = DateTime.parse(row[0])
        @last_time = time
        r << {
          country: @country,
          production_type: @production_type,
          time: time,
          value: row[1].to_f,
        }
      end
      #require 'pry' ; binding.pry

      r
    end

    def last_time
      @last_time
    end
  end
end
