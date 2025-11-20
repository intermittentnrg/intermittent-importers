require 'faraday/net_http_persistent'
require 'faraday/retry'
require 'faraday/gzip'
require 'chronic'
require 'fastest_csv'
require 'ox'
require 'csv'

module Ieso
  class Base
    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
    TZ = TZInfo::Timezone.get('EST')
    FUEL_MAP = {
      "NUCLEAR" => "nuclear",
      "GAS" => "fossil_gas",
      "HYDRO" => "hydro",
      "WIND" => "wind_onshore",
      "SOLAR" => "solar",
      "BIOFUEL" => "biomass",
      "OTHER" => "other",
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

    def initialize(date_or_path)
      @from = date_or_path
      if date_or_path.is_a? Date
        if self.class::PERIOD == 1.year
          @from = @from.beginning_of_year
        elsif self.class::PERIOD == 1.month
          @from = @from.beginning_of_month
        end
        @to = @from + self.class::PERIOD
      end
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

    def parse_unit(unit_internal_id, production_type_name)
      @area ||= Area.find_by!(source: self.class.source_id, code: 'CA-ON')

      @units[unit_internal_id] ||= ::Unit.find_or_create_by!(area: @area, internal_id: unit_internal_id) do |unit|
        unit.name = unit_internal_id
        unit.production_type = ProductionType.find_by!(name: production_type_name)
      end
    end
  end

  class BaseDirectory < Base
    INDEX_TIME_FORMAT = '%d-%b-%Y %H:%M'

    def self.each
      logger.info("Fetch #{self::URL}")
      http = @@faraday.get(self::URL)
      rows = http.body.split(/\n/)
      raise 'no entries' if rows.empty?
      rows.each do |row|
        m = row.match(%r|<a href="(.*?)">.*</a>\s{2,}(.*?)\s{2,}|)
        next unless m
        next unless select_file?(m[1])
        url = self::URL + m[1]
        time = Time.strptime(m[2].strip, self::INDEX_TIME_FORMAT)
        time = self::TZ.local_to_utc(time)

        if DataFile.where(updated_at: time...Float::INFINITY, path: File.basename(url), source: self.source_id).exists?
          logger.debug "already processed #{File.basename(url)}"
          next
        end
        yield self.new(url)
      end
    end

    def initialize(url)
      @url = url
    end

    def fetch
      res = @@faraday.get(@url)
      @filedate = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)
      @body = res.body
    end
  end

  class Load < BaseDirectory
    include SemanticLogger::Loggable
    include Out::Load

    URL = 'https://reports-public.ieso.ca/public/RealtimeConstTotals/'
    #URL_FORMAT = URL + 'PUB_RealtimeConstTotals_%Y%m%d%H.csv'
    #PERIOD = 5.minutes

    def self.cli(args)
      raise 'FIXME'
    end

    def self.select_file? url
      url =~ /PUB_RealtimeConstTotals_\d+\.csv/
    end

    def points_load
      fetch
      csv = FastestCSV.parse(@body)
      date = csv[0][1]

      r = []
      csv[4..].each do |row|
        #0:Hour
        hour = row[0].to_i - 1
        #1:Period
        minute = (row[1].to_i - 1) * 5
        time = Time.strptime "#{date} #{hour} #{minute}", '%Y%m%d %H %M'
        time = TZ.local_to_utc(time)
        #2:Total Energy / Market Demand
        value = row[2].to_i*1000
        #Total 10S
        #Total 10N
        #Total 30R
        #Total DISP LOAD
        #Total LOAD
        #Total LOSS

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

  class LoadYear < Base
    include SemanticLogger::Loggable
    include Out::Load

    URL_FORMAT = 'https://reports-public.ieso.ca/public/Demand/PUB_Demand_%Y.csv'
    PERIOD = 1.year

    def self.cli(args)
      if args.length != 1
        $stderr.puts "#{$0} <year>"
        exit 1
      end
      year = Chronic.parse(args.shift).to_date

      e = self.new year
      e.process
    end

    def points_load
      fetch
      r = []
      CSV.parse(@body, skip_lines: /^(\\|Date)/, headers: false) do |row|
        #0:Date
        date = row[0]
        #1:Hour
        hour = row[1].to_i - 1
        time = Time.strptime("#{date} #{hour}", '%Y-%m-%d %H')
        time = TZ.local_to_utc(time)
        #2:Market Demand
        value = row[2].to_i*1000
        #3: Ontario Demand

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

    URL_FORMAT = 'https://reports-public.ieso.ca/public/GenOutputCapabilityMonth/PUB_GenOutputCapabilityMonth_%Y%m.csv'
    PERIOD = 1.month

    def initialize(date)
      super
      @units = {}
    end

    def process
      fetch
      @from = TZ.utc_to_local(@from.to_time.beginning_of_month)
      @to = @from + 1.month

      r = []
      logger.benchmark_info("csv parse") do
        csv = FastestCSV.parse(@body)
        csv[4..].each do |row|
          #0:Delivery Date
          date = Time.strptime(row[0], '%Y-%m-%d')
          #1:Generator
          unit_internal_id = row[1]
          #2:Fuel Type
          type = FUEL_MAP[row[2]]
          #3:Measurement
          measurement = row[3]
          next unless measurement == "Output"

          unit = parse_unit(unit_internal_id, type)

          #4..:Hour X
          hours = row[4..]
          hours.each_with_index do |value, hour|
            next if value.nil?
            time = date + hour.to_i.hours
            time = TZ.local_to_utc(time)
            value = value.to_i*1000
            r << {time:, unit_id: unit.id, value:}
          end
        end
      end
      #require 'pry' ; binding.pry

      Out2::Unit.run(r, @from, @to, self.class.source_id)
    end
  end

  class Unit < BaseDirectory
    include SemanticLogger::Loggable

    def self.cli(args)
      raise 'FIXME'
    end

    URL = 'https://reports-public.ieso.ca/public/GenOutputCapability/'
    #PERIOD = 1.day

    def self.select_file? url
      url =~ /PUB_GenOutputCapability_\d+\.xml/
    end

    def initialize(url)
      super
      @units = {}
    end

    def process
      fetch
      doc = Ox.load(@body, mode: :hash_no_attrs)[:IMODocument][:IMODocBody]
      date = Time.strptime(doc[:Date], '%Y-%m-%d')
      base_time = TZ.local_to_utc(date.to_time)
      @from = base_time
      @to = @from + 1.day
      fuel_sums = {}
      r_unit = []
      r_gen = {}
      doc[:Generators][:Generator].each do |g|
        unit_internal_id = g[:GeneratorName]
        type = FUEL_MAP[g[:FuelType]]
        unit = parse_unit(unit_internal_id, type)

        out_sum = fuel_sums[type] ||= {}
        g[:Outputs][:Output].each do |o|
          time = base_time + (o[:Hour].to_i - 1).hours
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
      done!
    end
  end

  class GenerationMonth < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL_FORMAT = 'https://reports-public.ieso.ca/public/GenOutputbyFuelHourly/PUB_GenOutputbyFuelHourly_%Y.xml'
    PERIOD = 1.year

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
        $stderr.puts "#{$0} <date>"
        $stderr.puts "#{$0} <path>"
        exit 1
      end
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
            time = date + (hourly_data[:Hour].to_i - 1).hours
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

  class Price < BaseDirectory
    include SemanticLogger::Loggable

    URL = 'https://reports-public.ieso.ca/public/DispUnconsHOEP/'
    #URL_FORMAT = 'https://reports-public.ieso.ca/public/DispUnconsHOEP/PUB_DispUnconsHOEP_%Y%m%d.csv'
    #PERIOD = 1.day

    def self.cli(args)
      raise 'FIXME'
    end

    def self.select_file? url
      url =~ /PUB_DispUnconsHOEP_\d+\.csv/
    end

    def process
      fetch
      csv = FastestCSV.parse(@body)
      date = csv[0][1]

      r = []
      base_time = TZ.local_to_utc(date.to_time)
      csv[4..].each do |row|
        #0:Hour
        hour = row[0].to_i - 1
        time = base_time + hour.hours
        #1:Price
        r << {
          time:,
          value: row[1].to_f*100,
          country: 'CA-ON'
        }
      end

      ::Out2::Price.run(r, @from, @to, self.class.source_id)
      done!
    end
  end

  class PriceYear < Base
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 1
        $stderr.puts "#{$0} <year>"
        exit 1
      end
      year = Chronic.parse(args.shift).to_date

      e = self.new(year)
      e.process
    end

    URL_FORMAT = 'https://reports-public.ieso.ca/public/PriceHOEPPredispOR/PUB_PriceHOEPPredispOR_%Y.csv'
    PERIOD = 1.year

    def process
      fetch
      r = []
      csv = FastestCSV.parse(@body)
      csv[4..].each do |row|
        #0:Date
        date = row[0]
        #1:Hour
        hour = row[1].to_i - 1

        time = Time.strptime("#{date} #{hour}", '%Y-%m-%d %H')
        time = TZ.local_to_utc(time)
        #2:HOEP
        value = row[2].to_f*100
        #Hour 1 Predispatch
        #Hour 2 Predispatch
        #Hour 3 Predispatch
        #OR 10 Min Sync
        #OR 10 Min non-sync
        #OR 30 Min

        r << {
          time:,
          value:,
          country: 'CA-ON'
        }
      end
      #require 'pry' ; binding.pry

      ::Out2::Price.run(r, @from, @to, self.class.source_id)
      done!
    end
  end

  class Intertie < Base
    include SemanticLogger::Loggable
    include Out::Transmission

    URL_FORMAT = 'https://reports-public.ieso.ca/public/IntertieScheduleFlow/PUB_IntertieScheduleFlow_%Y%m%d.xml'
    PERIOD = 1.day
    MAP_EXCHANGE = {
      "MANITOBA" => ["CA-ON", "CA-MB"],
      "MANITOBA SK" => ["CA-ON", "CA-MB"],
      "MICHIGAN" => ["CA-ON", "US-MISO"],
      "MINNESOTA" => ["CA-ON", "US-MISO"],
      "NEW-YORK" => ["CA-ON", "US-NYISO"],
      "PQ.AT" => ["CA-ON", "CA-QC"],
      "PQ.B5D.B31L" => ["CA-ON", "CA-QC"],
      "PQ.D4Z" => ["CA-ON", "CA-QC"],
      "PQ.D5A" => ["CA-ON", "CA-QC"],
      "PQ.H4Z" => ["CA-ON", "CA-QC"],
      "PQ.H9A" => ["CA-ON", "CA-QC"],
      "PQ.P33C" => ["CA-ON", "CA-QC"],
      "PQ.Q4C" => ["CA-ON", "CA-QC"],
      "PQ.X2Y" => ["CA-ON", "CA-QC"]
    }

    def self.parsers_each
      from = ::Transmission.joins(areas_area: :from_area).where("time > ?", 2.months.ago).where(from_area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield self.new date
      end
    end

    def self.cli(args)
      case args.length
      when 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).each do |date|
          new(date).process
        rescue EmptyError
          logger.warn "EmptyError #{date}"
        end
      when 1
        if File.exist?(args[0])
          self.new(args[0]).process
        else
          date = Chronic.parse(args[0]).to_date
          self.new(date).process
        end
      else
        $stderr.puts "#{$0}: date(year)"
        exit
      end
    end

    def points
      fetch
      doc = Ox.load(@body, mode: :hash_no_attrs)[:IMODocument][:IMODocBody]
      date = Time.strptime(doc[:Date], '%Y-%m-%d')
      r = {}
      doc[:IntertieZone].each do |zone|
        fromto = MAP_EXCHANGE[zone[:IntertieZoneName]]
        zone[:Actuals][:Actual].each do |row|
          time = date + (row[:Hour].to_i - 1).hours + (row[:Interval].to_i - 1) * 5.minutes
          time = TZ.local_to_utc(time)
          value = row[:Flow].to_f*1000

          k = fromto+[time]
          r[k] ||= {time:, from_area: fromto[0], to_area: fromto[1], value: 0}
          r[k][:value] -= value
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end

  class IntertieYear < Base
    include SemanticLogger::Loggable
    include Out::Transmission

    URL_FORMAT = 'https://reports-public.ieso.ca/public/IntertieScheduleFlowYear/PUB_IntertieScheduleFlowYear_%Y.csv'
    PERIOD = 1.year
    MAP_EXCHANGE = Intertie::MAP_EXCHANGE

    def self.cli(args)
      case args.length
      when 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).each do |date|
          next unless date.month == 1 && date.day == 1
          new(date).process
        rescue EmptyError
          logger.warn "EmptyError #{date}"
        end
      when 1
        if File.exist?(args[0])
          self.new(args[0]).process
        else
          date = Chronic.parse(args[0]).to_date
          self.new(date).process
        end
      else
        $stderr.puts "#{$0}: date(year)"
        exit
      end
    end

    def points
      fetch
      csv = FastestCSV.parse(@body)
      r = {}
      h_zone = csv[3]
      h = csv[4]

      csv[5..].each do |row|
        date = Time.strptime(row[0], '%Y-%m-%d')
        time = date + (row[1].to_i - 1).hours
        time = TZ.local_to_utc(time)
        i=4
        while h_zone[i]
          raise h[i].inspect if h[i] != 'Flow'
          break if h_zone[i] == 'Total'
          fromto = MAP_EXCHANGE[h_zone[i]]
          value = row[i].to_f*1000

          unless fromto
            require 'pry' ; binding.pry
          end

          k = fromto+[time]
          r[k] ||= {time:, from_area: fromto[0], to_area: fromto[1], value: 0}
          r[k][:value] -= value
          i += 3
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end
end
