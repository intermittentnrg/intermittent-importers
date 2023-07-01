require 'httparty'

module NationalGridESO
  class Base
    def self.source_id
      "nationalgrideso"
    end
  end

  class Demand < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def self.parsers_each
      yield self.new
    end
    def initialize
      fetch
    end
    def fetch
      url = "https://data.nationalgrideso.com/backend/dataset/7a12172a-939c-404c-b581-a6128b74f588/resource/177f6fa4-ae49-4182-81ea-0c6b35f26ca6/download/demanddataupdate.csv"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          debug_output: $stdout
        )
      end
    end

    def points
      r = []
      headers = @res[0].each_with_index.to_h.symbolize_keys!
      @res[1..].each do |row|
        time = (Time.strptime("#{row[0]} UTC", '%Y-%m-%d %Z') + (row[1].to_i * 30).minutes)

        r << {
          country: 'GB',
          production_type: 'wind_embedded',
          time: time,
          value: row[headers[:EMBEDDED_WIND_GENERATION]].to_f
        }
        r << {
          country: 'GB',
          production_type: 'solar_embedded',
          time: time,
          value: row[headers[:EMBEDDED_SOLAR_GENERATION]].to_f
        }
      end

      require 'pry' ; binding.pry
      @from = r.first[:time]
      @to = r.last[:time]
      r
    end
  end

  class HistoricalDemand < Demand
  end
end
