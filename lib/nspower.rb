require 'httparty'

module Nspower
  class Base
    def self.source_id
      "nspower"
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize
      url = "https://www.nspower.ca/library/CurrentLoad/CurrentMix.json"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: {contentType: :csv},
          #debug_output: $stdout
        )
      end

      @from = Time.at(@res.first['datetime'][6...-5].to_i)
      @to = Time.at(@res.last['datetime'][6...-5].to_i)
      #require 'pry' ; binding.pry
    end
    MAPPINGS = {
      "Solid Fuel" => :coal,
      "HFO/Natural Gas" => :fossil_gas
    }
    def points
      r = []
      @res.each do |row|
        time = Time.at(row.delete('datetime')[6...-5].to_i)
        row.delete "Imports"
        r << {
          time: time,
          country: 'CA-NS',
          production_type: :fossil_hard_coal,
          value: row.delete("Solid Fuel") + row.delete("CT's") + row.delete("LM 6000's")
        }
        row.each do |k,v|
          production_type = MAPPINGS[k] || k.downcase
          r << {
            time: time,
            country: 'CA-NS',
            production_type: production_type,
            value: v
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    def initialize
      url = "https://www.nspower.ca/library/CurrentLoad/CurrentLoad.json"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: {contentType: :csv},
          #debug_output: $stdout
        )
      end

      @from = Time.at(@res.first['datetime'][6...-5].to_i)
      @to = Time.at(@res.last['datetime'][6...-5].to_i)
    end
    def points
      r = []
      @res.each do |row|
        time = Time.at(row.delete('datetime')[6...-5].to_i)
        r << {
          time: time,
          country: 'CA-NS',
          value: row['Base Load']
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
