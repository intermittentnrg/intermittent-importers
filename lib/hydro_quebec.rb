require 'httparty'
module HydroQuebec
  class Base
    def self.source_id
      "hydroquebec"
    end
  end
  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize()
      url = "https://www.hydroquebec.com/data/documents-donnees/donnees-ouvertes/json/production.json"

      res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          #debug_output: $stdout
        )
      end

      @json = JSON.parse(res.body)
      @from = Time.parse(@json["dateStart"])
      @to = Time.parse(@json["dateEnd"])
    end

    ENGLISH = {
      "hydraulique" => :hydro,
      "thermique" => :thermal,
      "solaire" => :solar,
      "eolien" => :wind,
      "autres" => :biomass
    }
    def points_generation
      r=[]
      @json["details"].each do |row|
        time = Time.parse(row["date"])
        row["valeurs"].each do |k,v|
          next unless ENGLISH[k]
          r << {
            time: time,
            country: "CA-QC",
            production_type: ENGLISH[k],
            value: v*1000
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
