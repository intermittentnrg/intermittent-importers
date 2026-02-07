# frozen_string_literal: true

require 'faraday/retry'
require 'fast_jsonparser'
require 'chronic'

module Eia
  class Base
    TZ = TZInfo::Timezone.get('UTC')
    def self.source_id
      'eia'
    end
    FUEL_MAP = {
      'BAT' => 'battery',
      'COL' => 'fossil_hard_coal',
      'GEO' => 'geothermal',
      'NG' => 'fossil_gas',
      'NUC' => 'nuclear',
      'OIL' => 'fossil_oil',
      'OES' => 'storage',
      'OTH' => 'other',
      'PS' => 'hydro_pumped_storage',
      'SNB' => 'solar_with_battery',
      'SUN' => 'solar',
      'UES' => 'unknown_storage',
      'WAT' => 'hydro',
      'WND' => 'wind',
      'WNB' => 'wind_with_battery',
      'UNK' => 'unknown'
    }.freeze

    @@faraday = Faraday.new do |f|
      f.request :retry, {
        retry_statuses: [500, 502],
        interval: 1,
        backoff_factor: 2,
        max: 5
      }
    end

    def parse_time(time)
      Time.strptime(time, '%Y-%m-%dT%H') - 1.hour
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    URL = 'https://api.eia.gov/v2/electricity/rto/region-data/data/'

    def initialize
      @r_load = []
    end

    def self.cli(args)
      if args.length != 2
        warn "#{$PROGRAM_NAME} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |date|
        new.add_date(date).done!
      end
    end

    def self.each(&block)
      from = ::Load.joins(:area).where('time > ?',
                                       2.months.ago).where(area: { source: source_id }).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each(&block)
    end

    def add(date)
      add_date(date)
    end

    def add_date(date)
      add_date_range(date, date + 1.day)
    end

    def add_date_range(from, to, country = nil)
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime('%Y-%m-%d'),
        end: to.strftime('%Y-%m-%d'),
        offset: 0,
        'data[]': 'value',
        'facets[type][]': 'D'
      }
      query['facets[respondent][]'] = country if country

      loop do
        res = logger.benchmark_info("#{URL} #{query[:start]} #{query[:end]}") do
          @@faraday.get(URL, query)
        end
        json = logger.benchmark_info('json parse') do
          FastJsonparser.parse(res.body, symbolize_keys: false)
        end
        logger.info "eia.gov query execution: #{json['response']['query execution']}"
        logger.info "eia.gov count query execution: #{json['response']['count query execution']}"

        add_json(json)

        break if query[:offset] + json['response']['data'].length >= json['response']['total'].to_i

        query[:offset] += json['response']['data'].length
      end
      self
    end

    def add_json(json)
      json['response']['data'].each do |row|
        next if row['value'].nil?

        time = parse_time(row['period'])
        @r_load << {
          time:,
          country: row['respondent'],
          value: row['value'].to_f * 1000
        }
      end
      self
    end

    def done!
      return if @r_load.empty?

      @from = @r_load.min { |a, b| a[:time] <=> b[:time] }[:time]
      @to = @r_load.max { |a, b| a[:time] <=> b[:time] }[:time]

      @r_load = Validate.validate_load(@r_load, self.class.source_id)
      Out::Load.run(@r_load, @from, @to, self.class.source_id)
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    URL = 'https://api.eia.gov/v2/electricity/rto/fuel-type-data/data/'

    def initialize
      @r_gen = {}
    end

    def self.cli(args)
      if args.length < 2
        warn "#{$PROGRAM_NAME} <from> <to> [country ...]"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      # Process date range in daily chunks to avoid API limitations
      (from...to).each do |date|
        if args.present?
          args.each do |country|
            SemanticLogger.tagged(country) do
              new.add_date(date, country).done!
            end
          end
        else
          new.add_date(date).done!
        end
      end
    end

    def self.each(&block)
      from = ::Generation.joins(areas_production_type: :area).where('time > ?',
                                                                    2.months.ago).where(area: { source: source_id }).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each(&block)
    end

    def add(date)
      add_date(date)
    end

    def add_date(date, country = nil)
      add_date_range(date, date + 1.day, country)
    end

    def add_date_range(from, to, country = nil)
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime('%Y-%m-%d'),
        end: to.strftime('%Y-%m-%d'),
        'data[]': 'value'
        # 'facets[fueltype][]': '{}',
      }
      query['facets[respondent][]'] = country if country
      query[:offset] = 0

      loop do
        res = logger.benchmark_info("#{URL} #{query[:start]} #{query[:end]}") do
          @@faraday.get(URL, query)
        end
        json = logger.benchmark_info('json parse') do
          FastJsonparser.parse(res.body, symbolize_keys: false)
        rescue StandardError
          logger.error "Response body: #{res.body}"
          raise
        end
        logger.error "Response body (missing response.data): #{res.body}" unless json['response']['data']

        add_json(json)

        break if query[:offset] + json['response']['data'].length >= json['response']['total'].to_i

        query[:offset] += json['response']['data'].length
      end
      self
    end

    def add_json(json)
      json['response']['data'].each do |row|
        raise "Unknown fueltype: #{row['fueltype']}" if FUEL_MAP[row['fueltype']].nil?
        next if row['value'].nil?

        time = parse_time(row['period'])
        country = row['respondent']
        production_type = FUEL_MAP[row['fueltype']]
        value = row['value'].to_f * 1000

        k = [time, country, production_type]
        if @r_gen[k] && @r_gen[k][:value] != value
          logger.warn("#{country} different values #{@r_gen[k][:value]} != #{value}")
        end

        @r_gen[k] = {
          time:,
          country:,
          production_type:,
          value:
        }
      end
      self
    end

    def done!
      return if @r_gen.empty?

      @from = @r_gen.values.min { |a, b| a[:time] <=> b[:time] }[:time]
      @to = @r_gen.values.max { |a, b| a[:time] <=> b[:time] }[:time]

      @r_gen = Validate.validate_generation(@r_gen.values, self.class.source_id)
      Out::Generation.run(@r_gen, @from, @to, self.class.source_id)
    end
  end

  class Interchange < Base
    include SemanticLogger::Loggable

    URL = 'https://api.eia.gov/v2/electricity/rto/interchange-data/data/'

    def initialize
      @r_tran = {}
    end

    def self.cli(args)
      if args.length < 2
        warn "#{$PROGRAM_NAME} <from> <to> [country ...]"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |date|
        if args.present?
          args.each do |country|
            SemanticLogger.tagged(country) do
              new.add_date(date, country).done!
            end
          end
        else
          new.add_date(date).done!
        end
      end
    end

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

    def add_date(date, country = nil)
      add_date_range(date, date + 1.day, country)
    end

    def add_date_range(from, to, country = nil)
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime('%Y-%m-%d'),
        end: to.strftime('%Y-%m-%d'),
        'data[]': 'value'
      }
      query['facets[fromba][]'] = country if country
      query[:offset] = 0

      loop do
        res = logger.benchmark_info("#{URL} #{query[:start]} #{query[:end]}") do
          @@faraday.get(URL, query)
        end
        json = logger.benchmark_info('json parse') do
          FastJsonparser.parse(res.body, symbolize_keys: false)
        rescue StandardError
          logger.error "Response body: #{res.body}"
          raise
        end
        logger.error "Response body (missing response.data): #{res.body}" unless json['response']['data']

        add_json(json)

        break if query[:offset] + json['response']['data'].length >= json['response']['total'].to_i

        query[:offset] += json['response']['data'].length
      end
      self
    end

    def add_json(json)
      json['response']['data'].each do |row|
        next if row['value'].nil?

        time = parse_time(row['period'])
        from_area = row['fromba']
        to_area = row['toba']
        # invert value. export need to be measured as drain on from_area, but EIA measures output to to_area
        value = -row['value'].to_f * 1000

        k = [time, from_area, to_area]
        if @r_tran[k] && @r_tran[k][:value] != value
          logger.warn("#{row.inspect} different values #{@r_tran[k]} != #{value}")
        end

        @r_tran[k] = {
          time:,
          from_area:,
          to_area:,
          value:
        }
      end
      self
    end

    def done!
      return if @r_tran.empty?

      @from = @r_tran.values.min { |a, b| a[:time] <=> b[:time] }[:time]
      @to = @r_tran.values.max { |a, b| a[:time] <=> b[:time] }[:time]

      Out::Transmission.run(@r_tran.values, @from, @to, self.class.source_id)
    end
  end
end
