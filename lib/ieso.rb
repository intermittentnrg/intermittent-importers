require 'faraday/net_http_persistent'
require 'faraday/retry'
require 'faraday/gzip'
require 'chronic'

module Ieso
  HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'

  class Base
    TZ = TZInfo::Timezone.get('EST')
    FUEL_MAP = {
      "NUCLEAR" => "nuclear",
      "GAS" => "fossil_gas",
      "HYDRO" => "hydro",
      "WIND" => "wind_onshore",
      "SOLAR" => "solar",
      "BIOFUEL" => "biomass",
    }
    def self.source_id
      "ieso"
    end

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      f.request :retry, {
        retry_statuses: [500, 502],
        interval: 1,
        backoff_factor: 2,
        max: 5
      }
      f.request :gzip
      #f.response :logger #, logger
    end

    def fetch
      if @from.is_a? Date
        @url = @from.strftime(self.class::URL_FORMAT)
        @filedate = DataFile.where(path: File.basename(@url), source: self.class.source_id).pluck(:updated_at).first
        res = logger.benchmark_info(@url) do
          @@faraday.get(@url) do |req|
            if @filedate
              req.headers['If-Modified-Since'] = @filedate.strftime(HTTP_DATE_FORMAT)
            end
          end
        end
        if res.status == 304 || !res.success?
          raise EmptyError
        end
        @body = res.body
        @filedate = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)
      else
        @body = File.read(@from)
      end
    end

    def done!
      return unless @url
      DataFile.upsert({path: File.basename(@url), source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{File.basename(@url)}"
    end

    def parse_unit(unit_internal_id, production_type)
      @area ||= Area.find_by!(source: self.class.source_id, code: 'CA-ON')

      @units[unit_internal_id] ||= ::Unit.
                                     create_with(name: unit_internal_id,
                                                 production_type:).
                                     find_or_create_by!(area: @area, internal_id: unit_internal_id)
    end
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    URL_FORMAT = 'http://reports.ieso.ca/public/Demand/PUB_Demand_%Y.csv'

    def self.cli(args)
      if args.length != 1
        $stderr.puts "#{$0} <year>"
        exit 1
      end
      year = Chronic.parse(args.shift).to_date

      e = Ieso::Load.new year
      e.process
    end

    def initialize(date)
      @from = date.beginning_of_year
      @to = date.end_of_year

      fetch
    end
    def points_load
      r = []
      CSV.parse(@body, skip_lines: /^(\\|Date)/, headers: false) do |row|
        time = Time.strptime("#{row[0]} #{row[1]}", '%Y-%m-%d %H')
        time = Ieso::Base::TZ.local_to_utc(time)
        value = row[3].to_i*1000
        r << {
          time:,
          country: 'CA-ON',
          value:
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end

  class UnitMonth < Base
    include SemanticLogger::Loggable
    include Out::Unit

    def self.cli(args)
      case args.length
      when 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).each do |date|
          next unless date.day == 1
          new(date).process
        rescue EmptyError
          logger.warn "EmptyError #{date}"
        end
      when 1
        if File.exist? args[0]
          new(args[0]).process
        else
          new(Chronic.parse(args[0]).to_date).process
        end
      else
        $stderr.puts "#{$0} <from> <to>"
        $stderr.puts "#{$0} <date_or_path>"
        exit 1
      end
    end

    URL_FORMAT = 'http://reports.ieso.ca/public/GenOutputCapabilityMonth/PUB_GenOutputCapabilityMonth_%Y%m.csv'
    def initialize(date)
      @from = date
      @units = {}
    end

    def points
      fetch
      @from = TZ.utc_to_local(@from.to_time.beginning_of_month)
      @to = @from + 1.month

      r = []
      CSV.parse(@body, skip_lines: /^(\\|Delivery Date)/, headers: false) do |row|
        date = Time.strptime(row[0], '%Y-%m-%d')
        unit_internal_id = row[1]
        type = FUEL_MAP[row[2]]
        measurement = row[3]
        next unless measurement == "Output"

        production_type = ProductionType.find_by!(name: type)
        unit = parse_unit(unit_internal_id, production_type)

        hours = row[4..]
        hours.each_with_index do |value, hour|
          next if value.nil?
          time = date + hour.to_i.hours
          time = TZ.local_to_utc(time)
          value = value.to_f*1000
          r << {time:, unit_id: unit.id, value:}
        end
      end
      #require 'pry' ; binding.pry

      r
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
        e = Ieso::Generation.new(time)
        e.process
      end
    end

    URL_FORMAT = 'http://reports.ieso.ca/public/GenOutputCapability/PUB_GenOutputCapability_%Y%m%d.xml'

    def initialize(date)
      @from = date
      @to = date + 1.day
      @units = {}
    end

    def process
      fetch
      doc = Ox.load(@body, mode: :hash_no_attrs)[:IMODocument][:IMODocBody]
      date = Time.strptime(doc[:Date], '%Y-%m-%d')
      fuel_sums = {}
      r_unit = []
      r_gen = {}
      doc[:Generators][:Generator].each do |g|
        unit_internal_id = g[:GeneratorName]
        type = FUEL_MAP[g[:FuelType]]
        production_type = ProductionType.find_by!(name: type)
        unit = parse_unit(unit_internal_id, production_type)

        out_sum = fuel_sums[type] ||= {}
        g[:Outputs][:Output].each do |o|
          time = date + (o[:Hour].to_i - 1).hours
          time = TZ.local_to_utc(time)
          value = o[:EnergyMW].to_i*1000
          out_sum[time] ||= 0
          out_sum[time] += value
          k = [time,type]
          r_gen[k] ||= {country: 'CA-ON', production_type: type, time: time, value: 0}
          r_gen[k][:value] += value
          r_unit << {time:, unit_id: unit.id, value:}
        end
      end
      #require 'pry' ; binding.pry

      Out2::Unit.run(r_unit, @from, @to, self.class.source_id)
      Out2::Generation.run(r_gen.values, @from, @to, self.class.source_id)
    end
  end

  class GenerationMonth < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL_FORMAT = 'http://reports.ieso.ca/public/GenOutputbyFuelHourly/PUB_GenOutputbyFuelHourly_%Y.xml'

    def self.cli(args)
      case args.length
      when 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).each do |date|
          next unless date.day == 1 && date.month == 1
          new(date).process
        rescue EmptyError
          logger.warn "EmptyError #{date}"
        end
      when 1
        if File.exist? args[0]
          new(args[0]).process
        else
          new(Chronic.parse(args[0]).to_date).process
        end
      else
        $stderr.puts "#{$0} <from> <to>"
        $stderr.puts "#{$0} <date_or_path>"
        exit 1
      end
    end

    def initialize(date_or_path)
      @from = date_or_path
    end

    def points_generation
      #@to = @from.end_of_year
      fetch
      r = []
      doc = Ox.load(@body, mode: :hash_no_attrs)[:Document][:DocBody]
      @from = Time.strptime(doc[:DeliveryYear], '%Y')
      @from = TZ.local_to_utc(@from)
      @to = @from + 1.year
      doc[:DailyData].each do |daily_data|
        date = Date.strptime(daily_data[:Day], '%Y-%m-%d')
        daily_data[:HourlyData].each do |hourly_data|
          hourly_data[:FuelTotal].each do |fuel_data|
            time = date + (hourly_data[:Hour].to_i-1).hours
            time = TZ.local_to_utc(time)
            production_type = FUEL_MAP[fuel_data[:Fuel]]
            value = fuel_data[:EnergyValue][:Output].to_f*1000
            r << {country: 'CA-ON', time:, production_type:, value:}
          end
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end

  class Price < Base
    include SemanticLogger::Loggable
    include Out::Price

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Ieso::Price.new(time)
        e.process_price
      end
    end

    def self.parsers_each
      from = ::Price.joins(:area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield self.new date
      end
    end

    URL_FORMAT = 'http://reports.ieso.ca/public/DispUnconsHOEP/PUB_DispUnconsHOEP_%Y%m%d.csv'

    def initialize(date)
      @from = date
    end

    def points_price
      @to = @from + 1.day
      fetch
      r = []
      base_time = TZ.local_to_utc(@from.to_time)
      CSV.parse(@body, skip_lines: /^(?!\s*\d)/, headers: false) do |row|
        time = base_time + row[0].to_i.hours
        r << {
          time:,
          value: row[1].to_f*100,
          country: 'CA-ON'
        }
      end

      r
    end
  end

  class PriceYear < Base
    include SemanticLogger::Loggable
    include Out::Price

    def self.cli(args)
      if args.length != 1
        $stderr.puts "#{$0} <year>"
        exit 1
      end
      year = Chronic.parse(args.shift).to_date

      e = Ieso::PriceYear.new(year)
      e.process
    end

    URL_FORMAT = 'http://reports.ieso.ca/public/PriceHOEPPredispOR/PUB_PriceHOEPPredispOR_%Y.csv'

    def initialize(date)
      @from = date.beginning_of_year
      @to = @from.end_of_year
    end

    def points_price
      fetch
      r = []
      CSV.parse(@body, skip_lines: /^(?!\s*\d)/, headers: false) do |row|
        time = Time.strptime("#{row[0]} #{row[1]}", '%Y-%m-%d %H')
        time = TZ.local_to_utc(time)
        value = row[2].to_f*100
        r << {
          time:,
          value:,
          country: 'CA-ON'
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
