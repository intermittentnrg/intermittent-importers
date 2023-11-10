require 'faraday/follow_redirects'

module NationalGridEso
  class Base
    TZ = ActiveSupport::TimeZone.new('Europe/London')
    include SemanticLogger::Loggable

    def self.source_id
      "nationalgrideso"
    end
    @@faraday = Faraday.new do |f|
      f.response :follow_redirects
      f.response :logger, logger
    end
  end

  class DemandLive < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def self.cli(args)
      if args.length == 0
        $stderr.puts "#{$0} <from>"
        exit 1
      end
      #FIXME max 25 days
      # 1200 row limit
      # 1200/2/24=25 days

      from = Chronic.parse(args[0])
      new(from).process
    end

    def initialize(from)
      @from = from
      url = 'https://api.nationalgrideso.com/api/3/action/datastore_search_sql'
      options = {}
      options[:sql] = %Q{SELECT * FROM "177f6fa4-ae49-4182-81ea-0c6b35f26ca6" WHERE "SETTLEMENT_DATE" >= '#{from}'}
      options[:records_format] = 'csv'
      fetch(url, options)
    end

    def fetch(url, options={})
      res = logger.benchmark_info(url) do
        @@faraday.get(url, options)
      end
      @json = logger.benchmark_info("parse csv") do
        FastJsonparser.parse(res.body)
      end
    end

    def points_generation
      r = []
      @json[:result][:records].each do |row|
        date = TZ.strptime(row[:SETTLEMENT_DATE], '%Y-%m-%d')
        time = date + row[:SETTLEMENT_PERIOD].to_i*30.minutes
        r << {country: 'GB', production_type: 'wind_embedded', time:, value: row[:EMBEDDED_WIND_GENERATION].to_f*1000}
        r << {country: 'GB', production_type: 'solar_embedded', time:, value: row[:EMBEDDED_SOLAR_GENERATION].to_f*1000}
      end
      @to = r.last[:time]
      #require 'pry' ; binding.pry

      r
    end
  end

  class Demand < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def self.parsers_each
      yield self.new
    end
    def initialize
      # From https://www.nationalgrideso.com/data-portal/daily-demand-update
      url = "https://api.nationalgrideso.com/dataset/7a12172a-939c-404c-b581-a6128b74f588/resource/177f6fa4-ae49-4182-81ea-0c6b35f26ca6/download/demanddataupdate.csv"
      fetch(url)
    end

    def fetch(url, options={})
      res = logger.benchmark_info(url) do
        @@faraday.get(url, options)
      end
      @csv = logger.benchmark_info("parse csv") do
        FastestCSV.parse(res.body)
      end
    end

    DATE_FORMATS = {
      /\d{4}-\d{2}-\d{2}/ => '%Y-%m-%d %Z',
      /\d{2}-.{3}-\d{4}/ => '%d-%b-%Y %Z'
    }
    def points_generation
      r = {}
      headers = @csv[0].each_with_index.to_h.symbolize_keys!
      date_format = DATE_FORMATS.find { |rx, _| rx.match(@csv[1][0]) }[1]
      @csv[1..].each do |row|
        time = (Time.strptime("#{row[0]} UTC", date_format) + (row[1].to_i * 30).minutes)

        r[[time, :wind_embedded]] = {
          country: 'GB',
          production_type: 'wind_embedded',
          time: time,
          value: row[headers[:EMBEDDED_WIND_GENERATION]].to_f*1000
        }
        r[[time, :solar_embedded]] = {
          country: 'GB',
          production_type: 'solar_embedded',
          time: time,
          value: row[headers[:EMBEDDED_SOLAR_GENERATION]].to_f*1000
        }
      end
      #require 'pry' ; binding.pry
      r = r.values
      @from = r.first[:time]
      @to = r.last[:time]

      r
    end
  end

  class HistoricalDemand < Demand
    def self.parsers_each
      URLS.each do |url|
        yield self.new(url)
      end
    end
    def initialize(url)
      fetch(url)
    end
    URLS = %w[
      https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/bf5ab335-9b40-4ea4-b93a-ab4af7bce003/download/demanddata.csv
    ]
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/bb44a1b5-75b1-4db2-8491-257f23385006/download/demanddata_2022.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/18c69c42-f20d-46f0-84e9-e279045befc6/download/demanddata_2021.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/33ba6857-2a55-479f-9308-e5c4c53d4381/download/demanddata_2020.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/dd9de980-d724-415a-b344-d8ae11321432/download/demanddata_2019.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/fcb12133-0db0-4f27-a4a5-1669fd9f6d33/download/demanddata_2018.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/2f0f75b8-39c5-46ff-a914-ae38088ed022/download/demanddata_2017.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/3bb75a28-ab44-4a0b-9b1c-9be9715d3c44/download/demanddata_2016.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/cc505e45-65ae-4819-9b90-1fbb06880293/download/demanddata_2015.csv
      # https://api.nationalgrideso.com/dataset/8f2fe0af-871c-488d-8bad-960426f24601/resource/b9005225-49d3-40d1-921c-03ee2d83a2ff/download/demanddata_2014.csv
  end
end
