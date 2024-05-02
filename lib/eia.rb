require 'faraday/retry'
require 'fast_jsonparser'
require 'chronic'

module Eia
  class Base
    TZ = TZInfo::Timezone.get('UTC')
    def self.source_id
      "eia"
    end
    FUEL_MAP = {
      'COL' => 'fossil_hard_coal',
      'NG' => 'fossil_gas',
      'NUC' => 'nuclear',
      'OIL' => 'fossil_oil',
      'OTH' => 'other',
      'SUN' => 'solar',
      'WAT' => 'hydro',
      'WND' => 'wind',
      'UNK' => 'unknown'
    }

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
    include Out::Load

    URL = "https://api.eia.gov/v2/electricity/rto/region-data/data/"
    QUERY_PARAMS = {}

    def self.cli args
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Eia::Load.new from: time, to: time + 1.day
        e.process
      end
    end

    def self.parsers_each
      from = ::Load.joins(:area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield self.new from: date, to: date + 1.day
      end
    end

    def initialize(country: nil, from: nil, to: nil)
      @from = from
      @to = to + 1.hour
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime("%Y-%m-%d"),
        end: to.strftime("%Y-%m-%d"),
        offset: 0,
        'data[]': 'value',
        'facets[type][]': 'D'
      }
      query['facets[respondent][]'] = country if country
      @res = []
      loop do
        res = logger.benchmark_info("#{URL} #{query[:start]} #{query[:end]}") do
          @@faraday.get(URL, query)
        end
        res = logger.benchmark_info("json parse") do
          FastJsonparser.parse(res.body, symbolize_keys: false)
        end
        logger.info "eia.gov query execution: #{res['response']['query execution']}"
        logger.info "eia.gov count query execution: #{res['response']['count query execution']}"

        @res << res

        if query[:offset] + res['response']['data'].length >= res['response']['total'].to_i
          break
        end
        query[:offset] += res['response']['data'].length
      end
    end

    def points_load
      r = []
      @res.each do |res|
        res['response']['data'].each do |row|
          if row['value'].nil?
            logger.warn "Null value #{row.inspect}"
            next
          end
          if row['value'].to_i < 0
            logger.warn("Negative load #{row.inspect}")
            next
          end
          if row['respondent'] == 'BANC' && row['value'].to_i > 6000
            logger.warn("Ignoring load #{row['value']} from #{row['respondent']}")
            next
          end
          time = parse_time(row['period'])
          r << {
            time: time,
            country: row['respondent'],
            value: row['value'].to_i*1000
          }
        end
      end
      #require 'pry' ; binding.pry

      Validate.validate_load(r)
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = "https://api.eia.gov/v2/electricity/rto/fuel-type-data/data/"

    def self.cli args
      if args.length < 2
        $stderr.puts "#{$0} <from> <to> [country ...]"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      areas = {}
      production_types = {}
      #countries = args.present? ? args : Area.where(source: Eia::Generation.source_id).pluck(:internal_id)
      (from...to).each do |time|
        if args.present?
          args.each do |country|
            SemanticLogger.tagged(country) do
              Eia::Generation.new(from: time, to: time + 1.day, country: country).process
            end
          end
        else
          Eia::Generation.new(from: time, to: time + 1.day).process
        end
      end
    end

    def self.parsers_each
      from = ::Generation.joins(:areas_production_type => :area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield self.new from: date, to: date + 1.day
      end
    end

    def initialize(country: nil, from: nil, to: nil)
      @from = from
      @to = to + 1.hour
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime("%Y-%m-%d"),
        end: to.strftime("%Y-%m-%d"),
        'data[]': 'value',
        #'facets[fueltype][]': '{}',
      }
      query['facets[respondent][]'] = country if country
      query[:offset] = 0
      @res = []
      loop do
        res = logger.benchmark_info("#{URL} #{query[:start]} #{query[:end]}") do
          @@faraday.get(URL, query)
        end
        res = logger.benchmark_info("json parse") do
          FastJsonparser.parse(res.body, symbolize_keys: false)
        rescue
          logger.error "Response body: #{res.body}"
          raise
        end
        unless res['response']['data']
          logger.error "Response body (missing response.data): #{res.body}"
        end
        @res << res
        if query[:offset] + res['response']['data'].length >= res['response']['total'].to_i
          break
        end
        query[:offset] += res['response']['data'].length
      end
    end

    def points_generation
      r = {}
      @res.each do |res|
        res['response']['data'].each do |row|
          raise "Unknown fueltype: #{row['fueltype']}" if FUEL_MAP[row['fueltype']].nil?
          if row['value'].nil?
            logger.warn "Null value #{row.inspect}"
            next
          end
          time = parse_time(row['period'])
          country = row['respondent']
          production_type = FUEL_MAP[row['fueltype']]
          value = row['value'].to_i*1000
          k = [time,country,production_type]
          if r[k] && r[k][:value] != value
            logger.warn("#{country} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {
            time:,
            country:,
            production_type:,
            value:
          }
        end
      end
      #require 'pry' ; binding.pry

      Validate.validate_generation(r.values)
    end
  end
  class Interchange < Base
    include SemanticLogger::Loggable
    include Out::Transmission

    URL = "https://api.eia.gov/v2/electricity/rto/interchange-data/data/"

    def self.cli args
      if args.length < 2
        $stderr.puts "#{$0} <from> <to> [country ...]"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      areas = {}
      production_types = {}
      (from...to).each do |time|
        if args.present?
          args.each do |country|
            SemanticLogger.tagged(country) do
              new(from: time, to: time + 1.day, country: country).process
            end
          end
        else
          new(from: time, to: time + 1.day).process
        end
      end
    end

    def initialize(country: nil, from: nil, to: nil)
      @from = from
      @to = to + 1.hour
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime("%Y-%m-%d"),
        end: to.strftime("%Y-%m-%d"),
        'data[]': 'value',
      }
      query['facets[fromba][]'] = country if country
      query[:offset] = 0
      @res = []
      loop do
        res = logger.benchmark_info("#{URL} #{query[:start]} #{query[:end]}") do
          @@faraday.get(URL, query)
        end
        res = logger.benchmark_info("json parse") do
          FastJsonparser.parse(res.body, symbolize_keys: false)
        rescue
          logger.error "Response body: #{res.body}"
          raise
        end
        unless res['response']['data']
          logger.error "Response body (missing response.data): #{res.body}"
        end
        @res << res
        if query[:offset] + res['response']['data'].length >= res['response']['total'].to_i
          break
        end
        query[:offset] += res['response']['data'].length
      end
    end
    def points
      r = []
      @res.each do |res|
        res['response']['data'].each do |row|
          if row['value'].nil?
            logger.warn "Null value #{row.inspect}"
            next
          end
          time = parse_time(row['period'])
          from_area = row['fromba']
          to_area = row['toba']
          # invert value. export need to be measured as drain on from_area, but EIA measures output to to_area
          value = -row['value'].to_i*1000
          # k = [time,from_area,to_area]
          # if r[k] && r[k][:value] != value
          #   logger.warn("#{row.inspect} different values #{r[k]} != #{value}")
          # end

          #r[k] = {
          r << {
            time:,
            from_area:,
            to_area:,
            value:
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
