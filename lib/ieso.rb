# frozen_string_literal: true

require 'faraday/net_http_persistent'
require 'faraday/retry'
require 'faraday/gzip'
require 'chronic'
require 'fastest_csv'
require 'ox'
require 'csv'

module Ieso
  class Base
    include SemanticLogger::Loggable

    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
    TZ = TZInfo::Timezone.get('EST')
    FUEL_MAP = {
      'NUCLEAR' => 'nuclear',
      'GAS' => 'fossil_gas',
      'HYDRO' => 'hydro',
      'WIND' => 'wind_onshore',
      'SOLAR' => 'solar',
      'BIOFUEL' => 'biomass',
      'OTHER' => 'other'
    }.freeze
    def self.source_id
      'ieso'
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
      # f.response :logger #, logger
    end

    def initialize
      @datafiles = []
    end

    def add_date(date)
      @from = date
      @to = @from + self.class::PERIOD
      url = @from.strftime(self.class::URL_FORMAT)
      add_url(url)
      self
    end

    def add_url(url)
      last_modified = DataFile.last_modified(url, self.class.source_id)
      res = logger.benchmark_info(url) do
        @@faraday.get(url) do |req|
          req.headers['If-Modified-Since'] = last_modified if last_modified
        end
      end
      raise EmptyError if res.status == 304 || !res.success?

      body = res.body
      updated_at = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)
      @datafiles << { path: File.basename(url), source: self.class.source_id, updated_at: }
      add_buffer(body)
      self
    end

    def add_file(path)
      body = File.read(path)
      updated_at = File.mtime(path)
      @datafiles << { path: File.basename(path), source: self.class.source_id, updated_at: }
      add_buffer(body)
      self
    end

    def done!
      DataFile.upsert_all(@datafiles, unique_by: %i[source path])
      self
    end

    def parse_unit(unit_internal_id, production_type_name)
      @area ||= Area.find_by!(source: self.class.source_id, code: 'CA-ON')

      @units[unit_internal_id] ||= ::Unit.find_or_create_by!(area: @area, internal_id: unit_internal_id) do |unit|
        unit.name = unit_internal_id
        unit.production_type = ProductionType.find_by!(name: production_type_name)
      end
    end

    def self.cli(args)
      case args.length
      when 1
        if File.exist?(args[0])
          # Single file
          new.add_file(args[0]).done!
        else
          # Single date
          date = Chronic.parse(args[0]).to_date
          new.add_date(date).done!
        end
      when 2
        # Date range
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        period = self::PERIOD

        (from...to).each do |date|
          # Filter dates based on PERIOD
          if period == 1.year
            next unless date.day == 1 && date.month == 1
          elsif period == 1.month
            next unless date.day == 1
          end

          new.add_date(date).done!
        rescue EmptyError
          logger.warn "EmptyError #{date}"
        end
      else
        warn "#{$PROGRAM_NAME} <from> <to>"
        warn "#{$PROGRAM_NAME} <date_or_path>"
        exit 1
      end
    end
  end

  class BaseDirectory < Base
    include SemanticLogger::Loggable
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

        if DataFile.where(updated_at: time...Float::INFINITY, path: File.basename(url), source: source_id).exists?
          logger.debug "already processed #{File.basename(url)}"
          next
        end
        yield url
      end
    end

    def add(url)
      add_url(url)
    end
  end

  class Load < BaseDirectory
    include SemanticLogger::Loggable

    URL = 'https://reports-public.ieso.ca/public/RealtimeConstTotals/'
    # URL_FORMAT = URL + 'PUB_RealtimeConstTotals_%Y%m%d%H.csv'
    # PERIOD = 5.minutes

    def initialize
      super
      @r = []
    end

    def self.select_file?(url)
      url =~ /PUB_RealtimeConstTotals_\d+\.csv/
    end

    def add_buffer(body)
      csv = FastestCSV.parse(body)
      date = csv[0][1]

      csv[4..].each do |row|
        # 0:Hour
        hour = row[0].to_i - 1
        # 1:Period
        minute = (row[1].to_i - 1) * 5
        time = Time.strptime "#{date} #{hour} #{minute}", '%Y%m%d %H %M'
        time = TZ.local_to_utc(time)
        # 2:Total Energy / Market Demand
        value = row[2].to_i * 1000
        # Total 10S
        # Total 10N
        # Total 30R
        # Total DISP LOAD
        # Total LOAD
        # Total LOSS

        @r << {
          time:,
          country: 'CA-ON',
          value:
        }
      end
      # require 'pry' ; binding.pry

      self
    end

    def done!
      return if @r.empty?

      @r = Validate.validate_load(@r, self.class.source_id)
      Out::Load.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class LoadYear < Base
    include SemanticLogger::Loggable

    URL_FORMAT = 'https://reports-public.ieso.ca/public/Demand/PUB_Demand_%Y.csv'
    PERIOD = 1.year

    def initialize
      super
      @r = []
    end

    def add_buffer(body)
      CSV.parse(body, skip_lines: /^(\\|Date)/, headers: false) do |row|
        # 0:Date
        date = row[0]
        # 1:Hour
        hour = row[1].to_i - 1
        time = Time.strptime("#{date} #{hour}", '%Y-%m-%d %H')
        time = TZ.local_to_utc(time)
        # 2:Market Demand
        value = row[2].to_i * 1000
        # 3: Ontario Demand

        @r << {
          time:,
          country: 'CA-ON',
          value:
        }
      end
      self
    end

    def done!
      return if @r.empty?

      @r = Validate.validate_load(@r, self.class.source_id)
      Out::Load.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class UnitMonth < Base
    include SemanticLogger::Loggable

    URL_FORMAT = 'https://reports-public.ieso.ca/public/GenOutputCapabilityMonth/PUB_GenOutputCapabilityMonth_%Y%m.csv'
    PERIOD = 1.month

    def initialize
      super
      @units = {}
      @r = []
    end

    def add_buffer(body)
      logger.benchmark_info('csv parse') do
        csv = FastestCSV.parse(body)
        csv[4..].each do |row|
          # 0:Delivery Date
          date = Time.strptime(row[0], '%Y-%m-%d')
          # 1:Generator
          unit_internal_id = row[1]
          # 2:Fuel Type
          type = FUEL_MAP[row[2]]
          # 3:Measurement
          measurement = row[3]
          next unless measurement == 'Output'

          unit = parse_unit(unit_internal_id, type)

          # 4..:Hour X
          hours = row[4..]
          hours.each_with_index do |value, hour|
            next if value.nil?

            time = date + hour.to_i.hours
            time = TZ.local_to_utc(time)
            value = value.to_i * 1000
            @r << { time:, unit_id: unit.id, value: }
          end
        end
      end
      self
    end

    def done!
      return if @r.empty?

      Out::Unit.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class Unit < BaseDirectory
    include SemanticLogger::Loggable

    URL = 'https://reports-public.ieso.ca/public/GenOutputCapability/'
    URL_FORMAT = "#{URL}PUB_GenOutputCapability_%Y%m%d.xml".freeze
    PERIOD = 1.day

    def initialize
      super
      @units = {}
      @r_unit = []
      @r_gen = {}
    end

    def self.select_file?(url)
      url =~ /PUB_GenOutputCapability_\d+\.xml/
    end

    def add_buffer(body)
      doc = Ox.load(body, mode: :hash_no_attrs)[:IMODocument][:IMODocBody]
      date = Time.strptime(doc[:Date], '%Y-%m-%d')
      base_time = TZ.local_to_utc(date.to_time)
      @from = base_time
      @to = @from + 1.day
      fuel_sums = {}
      doc[:Generators][:Generator].each do |g|
        unit_internal_id = g[:GeneratorName]
        type = FUEL_MAP[g[:FuelType]]
        unit = parse_unit(unit_internal_id, type)

        out_sum = fuel_sums[type] ||= {}
        g[:Outputs][:Output].each do |o|
          time = base_time + (o[:Hour].to_i - 1).hours
          value = o[:EnergyMW].to_i * 1000
          out_sum[time] ||= 0
          out_sum[time] += value
          k = [time, type]
          @r_gen[k] ||= { country: 'CA-ON', production_type: type, time: time, value: 0 }
          @r_gen[k][:value] += value
          @r_unit << { time:, unit_id: unit.id, value: }
        end
      end
      # require 'pry' ; binding.pry

      self
    end

    def done!
      return if @r_unit.empty? && @r_gen.empty?

      @from = [@r_unit.min { |a, b| a[:time] <=> b[:time] }[:time], @r_gen.values.min do |a, b|
        a[:time] <=> b[:time]
      end[:time]].min
      @to = [@r_unit.max { |a, b| a[:time] <=> b[:time] }[:time], @r_gen.values.max do |a, b|
        a[:time] <=> b[:time]
      end[:time]].max

      Out::Unit.run(@r_unit, @from, @to, self.class.source_id)
      Out::Generation.run(@r_gen.values, @from, @to, self.class.source_id)
      super
    end
  end

  class GenerationMonth < Base
    include SemanticLogger::Loggable

    URL_FORMAT = 'https://reports-public.ieso.ca/public/GenOutputbyFuelHourly/PUB_GenOutputbyFuelHourly_%Y.xml'
    PERIOD = 1.year

    def initialize
      super
      @r = []
    end

    def add_buffer(body)
      doc = Ox.load(body, mode: :hash_no_attrs)[:Document][:DocBody]
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
            value = fuel_data[:EnergyValue][:Output].to_f * 1000
            @r << { country: 'CA-ON', time:, production_type:, value: }
          end
        end
      end
      self
    end

    def done!
      return if @r.empty?

      @r = Validate.validate_generation(@r, self.class.source_id)
      Out::Generation.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class Price < BaseDirectory
    include SemanticLogger::Loggable

    URL = 'https://reports-public.ieso.ca/public/DispUnconsHOEP/'
    # URL_FORMAT = 'https://reports-public.ieso.ca/public/DispUnconsHOEP/PUB_DispUnconsHOEP_%Y%m%d.csv'
    # PERIOD = 1.day

    def initialize
      super
      @r = []
    end

    def self.select_file?(url)
      url =~ /PUB_DispUnconsHOEP_\d+\.csv/
    end

    def add_buffer(body)
      csv = FastestCSV.parse(body)
      date = csv[0][1]

      base_time = TZ.local_to_utc(date.to_time)
      csv[4..].each do |row|
        # 0:Hour
        hour = row[0].to_i - 1
        time = base_time + hour.hours
        # 1:Price
        @r << {
          time:,
          value: row[1].to_f * 100,
          country: 'CA-ON'
        }
      end

      self
    end

    def done!
      return if @r.empty?

      ::Out::Price.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class PriceYear < Base
    include SemanticLogger::Loggable

    URL_FORMAT = 'https://reports-public.ieso.ca/public/PriceHOEPPredispOR/PUB_PriceHOEPPredispOR_%Y.csv'
    PERIOD = 1.year

    def initialize
      super
      @r = []
    end

    def add_buffer(body)
      csv = FastestCSV.parse(body)
      csv[4..].each do |row|
        # 0:Date
        date = row[0]
        # 1:Hour
        hour = row[1].to_i - 1

        time = Time.strptime("#{date} #{hour}", '%Y-%m-%d %H')
        time = TZ.local_to_utc(time)
        # 2:HOEP
        value = row[2].to_f * 100
        # Hour 1 Predispatch
        # Hour 2 Predispatch
        # Hour 3 Predispatch
        # OR 10 Min Sync
        # OR 10 Min non-sync
        # OR 30 Min

        @r << {
          time:,
          value:,
          country: 'CA-ON'
        }
      end
      self
    end

    def done!
      return if @r.empty?

      ::Out::Price.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class Intertie < Base
    include SemanticLogger::Loggable

    URL_FORMAT = 'https://reports-public.ieso.ca/public/IntertieScheduleFlow/PUB_IntertieScheduleFlow_%Y%m%d.xml'
    PERIOD = 1.day
    MAP_EXCHANGE = {
      'MANITOBA' => %w[CA-ON CA-MB],
      'MANITOBA SK' => %w[CA-ON CA-MB],
      'MICHIGAN' => %w[CA-ON US-MISO],
      'MINNESOTA' => %w[CA-ON US-MISO],
      'NEW-YORK' => %w[CA-ON US-NYISO],
      'PQ.AT' => %w[CA-ON CA-QC],
      'PQ.B5D.B31L' => %w[CA-ON CA-QC],
      'PQ.D4Z' => %w[CA-ON CA-QC],
      'PQ.D5A' => %w[CA-ON CA-QC],
      'PQ.H4Z' => %w[CA-ON CA-QC],
      'PQ.H9A' => %w[CA-ON CA-QC],
      'PQ.P33C' => %w[CA-ON CA-QC],
      'PQ.Q4C' => %w[CA-ON CA-QC],
      'PQ.X2Y' => %w[CA-ON CA-QC]
    }.freeze

    def self.each(&block)
      from = ::Transmission.joins(areas_area: :from_area).where('time > ?',
                                                                2.months.ago).where(from_area: { source: source_id }).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each(&block)
    end

    def add(date)
      add_date(date)
    end

    def add_buffer(body)
      doc = Ox.load(body, mode: :hash_no_attrs)[:IMODocument][:IMODocBody]
      date = Time.strptime(doc[:Date], '%Y-%m-%d')
      @r = {}
      doc[:IntertieZone].each do |zone|
        fromto = MAP_EXCHANGE[zone[:IntertieZoneName]]
        zone[:Actuals][:Actual].each do |row|
          time = date + (row[:Hour].to_i - 1).hours + (row[:Interval].to_i - 1) * 5.minutes
          time = TZ.local_to_utc(time)
          value = row[:Flow].to_f * 1000

          k = fromto + [time]
          @r[k] ||= { time:, from_area: fromto[0], to_area: fromto[1], value: 0 }
          @r[k][:value] -= value
        end
      end
      # require 'pry' ; binding.pry

      self
    end

    def done!
      return if @r.empty?

      Out::Transmission.run(@r.values, @from, @to, self.class.source_id)
      super
    end
  end

  class IntertieYear < Base
    include SemanticLogger::Loggable

    URL_FORMAT = 'https://reports-public.ieso.ca/public/IntertieScheduleFlowYear/PUB_IntertieScheduleFlowYear_%Y.csv'
    PERIOD = 1.year
    MAP_EXCHANGE = Intertie::MAP_EXCHANGE

    def initialize
      super
      @r = {}
    end

    def add_buffer(body)
      csv = FastestCSV.parse(body)
      h_zone = csv[3]
      h = csv[4]

      csv[5..].each do |row|
        date = Time.strptime(row[0], '%Y-%m-%d')
        time = date + (row[1].to_i - 1).hours
        time = TZ.local_to_utc(time)
        i = 4
        while h_zone[i]
          raise h[i].inspect if h[i] != 'Flow'
          break if h_zone[i] == 'Total'

          fromto = MAP_EXCHANGE[h_zone[i]]
          value = row[i].to_f * 1000

          unless fromto
            require 'pry'
            binding.pry
          end

          k = fromto + [time]
          @r[k] ||= { time:, from_area: fromto[0], to_area: fromto[1], value: 0 }
          @r[k][:value] -= value
          i += 3
        end
      end
      # require 'pry' ; binding.pry

      self
    end

    def done!
      return if @r.empty?

      Out::Transmission.run(@r.values, @from, @to, self.class.source_id)
      super
    end
  end
end
