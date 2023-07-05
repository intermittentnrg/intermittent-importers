require 'httparty'

module Nspower
  class Base
    def self.source_id
      "nspower"
    end
  end

  class Combined < Base
    include SemanticLogger::Loggable
    include Out::Generation
    include Out::Load

    def initialize
      load_url = "https://www.nspower.ca/library/CurrentLoad/CurrentLoad.json"
      @load = logger.benchmark_info(load_url) do
        HTTParty.get(
          load_url,
          query: {contentType: :csv},
          #debug_output: $stdout
        )
      end

      gen_url = "https://www.nspower.ca/library/CurrentLoad/CurrentMix.json"
      @gen = logger.benchmark_info(gen_url) do
        HTTParty.get(
          gen_url,
          query: {contentType: :csv},
          #debug_output: $stdout
        )
      end

      @from = Time.at(@load.first['datetime'][6...-5].to_i)
      @to = Time.at(@load.last['datetime'][6...-5].to_i)
      #require 'pry' ; binding.pry
    end
    GEN_MAPPINGS = {
      "Solid Fuel" => :coal,
      "HFO/Natural Gas" => :fossil_gas
    }

    def points_load
      @load_r = {}
      @load.each do |row|
        time = Time.at(row.delete('datetime')[6...-5].to_i)
        @load_r[time] = {
          time: time,
          country: 'CA-NS',
          value: row['Base Load']
        }
      end
      #require 'pry' ; binding.pry

      @load_r.values
    end

    def points_generation
      r = []
      @gen.each do |row|
        time = Time.at(row.delete('datetime')[6...-5].to_i)

        load = @load_r[time][:value]
        row.delete "Imports"
        r << {
          time: time,
          country: 'CA-NS',
          production_type: :fossil_hard_coal,
          value: load * (row.delete("Solid Fuel") + row.delete("CT's") + row.delete("LM 6000's")) / 100.0
        }
        row.each do |k,v|
          production_type = GEN_MAPPINGS[k] || k.downcase
          r << {
            time: time,
            country: 'CA-NS',
            production_type: production_type,
            value: load * v / 100.0
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end

    def process
      process_load
      process_generation
    end
  end
end
