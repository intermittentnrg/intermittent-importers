require 'faraday/net_http_persistent'
#require 'faraday/gzip'

module Caiso
  class Base
    TZ = TZInfo::Timezone.get('US/Pacific')
    def self.source_id
      "caiso"
    end

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      #f.request :gzip
      #f.response :logger #, logger
    end

    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'

    def initialize(date)
      @date = date
      @time = @date.to_time
      @from = TZ.local_to_utc(@time) { |periods| periods.first }
      @to = @from + 1.day
    end

    def fetch
      @filedate = DataFile.where(path: @url, source: self.class.source_id).pluck(:updated_at).first
      @csv = logger.benchmark_info(@url) do
        @res = @@faraday.get(@url) do |req|
          if @filedate
            req.headers['If-Modified-Since'] = @filedate.strftime(HTTP_DATE_FORMAT)
          end
        end
        FastestCSV.parse(@res.body)
      end
      if @res.status == 304 || @res.headers['content-type'] =~ /^text\/html/
        raise ENTSOE::EmptyError
      end
      #require 'pry' ; binding.pry
      @filedate = Time.strptime(@res.headers['Last-Modified'], HTTP_DATE_FORMAT)
      @fields = @csv.shift

      raise ENTSOE::EmptyError unless @fields.first
    end

    def parse_time(row)
      time = @date.to_time + Time.strptime(row[0], '%H:%M').seconds_since_midnight.seconds

      TZ.local_to_utc(time) { |periods| periods.first }
    end
    def done!
      DataFile.upsert({path: @url, source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{@filename}"
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Caiso::Generation.new(time)
        e.process
      rescue ENTSOE::EmptyError
        logger.warn "EmptyError #{time}"
      end
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

    def initialize(date)
      super
      #current: /outlook/SP/fuelsource.csv
      @url = "http://www.caiso.com/outlook/SP/History/#{date.strftime('%Y%m%d')}/fuelsource.csv"
    end

    def points_generation
      fetch
      raise @fields unless @fields.map(&:downcase) == FUELS.keys.map(&:downcase)
      r = []
      last_time = @from
      @csv.each do |row|
        next if row[1..].compact.blank?
        time = parse_time(row)
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
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    FIELDS = ["Time", "Hour ahead forecast", "Current demand", "Net demand"]

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Caiso::Load.new(time)
        e.process
      rescue ENTSOE::EmptyError
        logger.warn "EmptyError #{time}"
      end
    end

    def initialize(date)
      super
      #current: /outlook/SP/netdemand.csv
      @url = "http://www.caiso.com/outlook/SP/History/#{date.strftime('%Y%m%d')}/netdemand.csv"
    end

    def points_load
      fetch
      raise @fields.inspect unless @fields[0, FIELDS.length].map(&:downcase) == FIELDS.map(&:downcase)
      r = []
      last_time = @from
      @csv.each do |row|
        next if row[1..].compact.blank?
        time = parse_time(row)
        next if time < last_time
        last_time = time

        value = (row[2].to_f*1000).to_i
        r << {
          time:,
          value:,
          country: 'CAISO'
        }
      end
      #require 'pry' ; binding.pry

      Validate::validate_load(r)
    end
  end
end
