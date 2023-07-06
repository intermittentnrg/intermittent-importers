require 'date'
require 'httparty'
require 'active_support'
require 'active_support/core_ext'

module Eirgrid
  class Wind
    @@tz = Time.find_zone('Europe/Dublin')

    def self.source_id
      "eirgrid"
    end

    def initialize(from: DateTime.now.beginning_of_day, to: DateTime.now.end_of_day)
      @from = from
      @to = to

      fetch
    end

    def fetch
      @options = {
        area: 'windactual',
        region: 'ROI',
        datefrom: @from.strftime("%d-%B-%Y %H:%M"),
        dateto: @to.strftime("%d-%B-%Y %H:%M")
      }
      @res = HTTParty.get(
        "https://www.smartgriddashboard.com/DashboardService.svc/data",
        query: @options,
        #debug_output: $stdout
      )
    end

    def points
      r = []
      @res['Rows'].each do |row|
        next if row['Value'].nil?
        r << {
          production_type: 'wind_onshore',
          time: @@tz.strptime(row['EffectiveTime'], "%d-%B-%Y %H:%M:%S"),
          value: row['Value']
        }
      end

      r
    end
  end
end
