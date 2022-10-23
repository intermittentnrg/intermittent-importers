require 'httparty'
module Eia
  class Base
    def self.source_id
      "eia"
    end
    FUEL_MAP = {
      'COL' => 'fossil_hard_coal',
      'NG' => 'fossil_gas',
      'NUC' => 'nuclear',
      'OIL' => 'fossil_oil',
      'OTH' => 'other',
      'SUN' => 'solar',
      'WAT' => 'hydro',
      'WND' => 'wind_onshore'
    }
  end

  class Generation < Base
    @@logger = SemanticLogger[Generation]
    def initialize(country: nil, from: nil, to: nil)
      query = {
        api_key: ENV['EIA_TOKEN'],
        #length: 50000,
        'data[]': 'value',
        #'facets[fueltype][]': '{}',
      }
      query[:frequency] = 'hourly'
      query['facets[respondent][]'] = country if country
      query[:start] = from.strftime("%Y-%m-%d")
      query[:end] = to.strftime("%Y-%m-%d")
      query[:offset] = 0
      @res = []
      loop do
        res = HTTParty.get(
          "https://api.eia.gov/v2/electricity/rto/fuel-type-data/data/",
          query: query,
          #debug_output: $stdout
        )
        @res << res
        #require 'pry' ; binding.pry
        if query[:offset] + res.parsed_response['response']['data'].length >= res.parsed_response['response']['total']
          break
        end
        query[:offset] += res.parsed_response['response']['data'].length
      end
    end

    def points
      r = []
      @res.each do |res|
        res.parsed_response['response']['data'].each do |row|
          raise row['fueltype'] if FUEL_MAP[row['fueltype']].nil?
          if row['value'].nil?
            @@logger.warn "Skip #{row.inspect}"
            next
          end
          time = DateTime.strptime(row['period'], '%Y-%m-%dT%H')
          r << {
            time: time,
            country: "US-#{row['respondent']}",
            production_type: FUEL_MAP[row['fueltype']],
            value: row['value']
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
