require 'faraday'
require 'json'

module HydroQuebec
  class Base
    def self.source_id
      "hydroquebec"
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    URL = "https://www.hydroquebec.com/data/documents-donnees/donnees-ouvertes/json/production.json"

    ENGLISH = {
      "hydraulique" => :hydro,
      "thermique" => :thermal,
      "solaire" => :solar,
      "eolien" => :wind,
      "autres" => :biomass
    }.freeze

    def self.cli(args)
      raise "No arguments allowed" if args.any?
      new.add.done!
    end

    def initialize
      @r = []
      @from = nil
      @to = nil
    end

    def add
      res = logger.benchmark_info(URL) do
        Faraday.get(URL)
      end

      json = JSON.parse(res.body)
      @from = Time.parse(json["dateStart"])
      @to = Time.parse(json["dateEnd"])

      json["details"].each do |row|
        time = Time.parse(row["date"])
        row["valeurs"].each do |k, v|
          next unless ENGLISH[k]
          @r << {
            time: time,
            country: "CA-QC",
            production_type: ENGLISH[k],
            value: v * 1000
          }
        end
      end

      self
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
    end
  end
end
