#require 'faraday/gzip'

module Caiso
  TZ = TZInfo::Timezone.get('US/Pacific')
  class Base
    def self.source_id
      "caiso"
    end

    FUELS = {
      "Time" => nil,
      "Solar" => "solar",
      "Wind" => "wind_onshore",
      "Geothermal" => "geothermal",
      "Biomass" => "biomass",
      "Biogas" => "biogas",
      "Small hydro" => "hydro_small",
      "Coal" => "fossil_hard_coal",
      "Nuclear" => "nuclear",
      "Natural Gas" => "fossil_gas",
      "Large Hydro" => "hydro_large",
      "Batteries" => "battery",
      "Imports" => nil,
      "Other" => "other",
    }
    FUEL_MAP = FUELS.values
  end
  HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @date = date
      @time = @date.to_time
      @from = TZ.local_to_utc(@time) { |periods| periods.first }
      @to = @from + 1.day
      #current: /outlook/SP/fuelsource.csv
      @url = "http://www.caiso.com/outlook/SP/History/#{date.strftime('%Y%m%d')}/fuelsource.csv"
      @filedate = DataFile.where(path: @url, source: self.class.source_id).pluck(:updated_at).first
      @csv = logger.benchmark_info(@url) do
        faraday = Faraday.new do |f|
          #f.request :gzip
          #f.response :logger, logger
        end
        @res = faraday.get(@url) do |req|
          if @filedate
            req.headers['If-Modified-Since'] = @filedate.strftime(HTTP_DATE_FORMAT)
          end
        end
        FastestCSV.parse(@res.body)
      end
      if @res.status == 304 # not modified
        raise ENTSOE::EmptyError
      end
      @filedate = Time.strptime(@res.headers['Last-Modified'], HTTP_DATE_FORMAT)
      @fields = @csv.shift

      raise ENTSOE::EmptyError unless @fields.first
      raise @fields unless @fields.map(&:downcase) == FUELS.keys.map(&:downcase)
      #require 'pry' ; binding.pry
    end

    def points_generation
      r = []
      last_time = @from
      @csv.each do |row|
        #require 'pry' ; binding.pry
        next if row[1..].compact.blank?
        #time = DateTime.strptime(@date.strftime("%Y-%m-%d ") + row[0], "%Y-%m-%d %H:%M")
        time = @date.to_time + Time.parse(row[0]).seconds_since_midnight.seconds
        time = TZ.local_to_utc(time) { |periods| periods.first }
        next if time < last_time
        last_time = time
        row.each_with_index do |value, type|
          next if type == 0 || type == 12
          raise type.to_s unless FUEL_MAP[type]
          type = FUEL_MAP[type]
          #next if type == 'Imports'
          r << {
            time: time,
            production_type: type,
            value: (value.to_f*1000).to_i,
            country: 'CAISO'
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
    def done!
      DataFile.upsert({path: @url, source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{@filename}"
    end
  end
end
