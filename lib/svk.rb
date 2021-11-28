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
    def initialize(area: nil, production: 'VI', from: nil, to: nil)
      @area = area
      @production = production
      @options = {
        PeriodFrom: DateTime.parse(from).strftime('%m/%d/%Y %H:%M:%S'), # 11/21/2021 00:00:00
        PeriodTo: DateTime.parse(to).strftime('%m/%d/%Y %H:%M:%S'), # 11/28/2021 00:00:00
        ConstraintAreaId: area,
        ProductionSortId: production
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
        r << {
          country: @area,
          production_type: @production,
          timestamp: DateTime.parse(row[0]),
          value: row[1].to_f,
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
