require 'httparty'
module HydroQuebec
  #PROXY = ["167.99.184.232", 3128]
  #PROXY = ["173.176.14.246", 3128]
  #PROXY = ["142.93.108.171", 3128]
  PROXY = ["192.99.154.187", 3128]

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
          http_proxyaddr: PROXY[0],
          http_proxyport: PROXY[1],
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
            value: v
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
