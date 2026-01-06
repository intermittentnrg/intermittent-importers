require 'faraday'
module HydroQuebec
  class Base
    def self.source_id
      "hydroquebec"
    end
  end
  class Generation < Base
    include SemanticLogger::Loggable

    def initialize()
      url = "https://www.hydroquebec.com/data/documents-donnees/donnees-ouvertes/json/production.json"

      res = logger.benchmark_info(url) do
        Faraday.get(url)
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
    def process
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

      Out::Generation.run(r, @from, @to, self.class.source_id)
    end
  end
end
