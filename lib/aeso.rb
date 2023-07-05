require 'httparty'

module Aeso
  class Base
    def self.source_id
      "aeso"
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize
      url = "http://ets.aeso.ca/ets_web/ip/Market/Reports/CSDReportServlet"
      res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: {contentType: :csv},
          #debug_output: $stdout
        )
      end
      @chunks = res.body.split("\r\n\r\n")
      @time = Time.parse(@chunks[1])
      @from = @time
      @to = @time + 1.minute
    end

    MAPPING = {
      "ENERGY STORAGE" => :battery,
      "GAS" => :fossil_gas,
      "COAL" => :fossil_hard_coal
    }

    def points_generation
      r = []
      csv = FastestCSV.parse(@chunks[3])
      csv.each do |row|
        production_type = MAPPING[row[0]] || row[0].downcase.gsub(/ /, '_')
        next if production_type == 'total'
        value = row[2]

        r << {
          time: @time,
          country: 'CA-AB',
          production_type: production_type,
          value: value
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
