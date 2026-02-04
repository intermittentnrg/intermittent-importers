require 'faraday/net_http_persistent'
#require 'faraday/gzip'
require 'fastest_csv'
require 'chronic'

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

    def initialize
      @datafiles = []
    end

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      e = self.new
      (from...to).each do |time|
        e.add_date(time)
      rescue EmptyError
        logger.warn "EmptyError #{time}"
      end
      e.done!
    end

    def add_date(date)
      @date = date
      @time = @date.to_time
      @from = TZ.local_to_utc(@time) { |periods| periods.first }
      @to = @from + 1.day
      url = date.strftime(self.class::URL_FORMAT)

      last_modified = DataFile.last_modified(url, self.class.source_id)
      res = @@faraday.get(url) do |req|
        req.headers['If-Modified-Since'] = last_modified if last_modified
      end

      if res.status == 304 || res.headers['content-type'] =~ /^text\/html/
        raise EmptyError
      end

      filedate = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)

      add_buffer(res.body)
      @datafiles << {path: url, source: self.class.source_id, updated_at: filedate}

      self
    end

    def add(date)
      add_date(date)
    end

    def parse_time(row)
      time = @date.to_time + Time.strptime(row[0], '%H:%M').seconds_since_midnight.seconds

      TZ.local_to_utc(time) { |periods| periods.first }
    end
    def done!
      DataFile.upsert_all(@datafiles, unique_by: [:source, :path])
      logger.info "done! #{@datafiles.map { |df| df[:path] }.join(', ')}"
    end
  end

  class FuelSource < Base
    include SemanticLogger::Loggable

    def self.each
      from = ::Generation.joins(:areas_production_type => :area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield date
      end
    end

    FUELS = {
      'Time' => nil,
      'Solar' => 'solar',
      'Wind' => 'wind_onshore',
      'Geothermal' => 'geothermal',
      'Biomass' => 'biomass',
      'Biogas' => 'biogas',
      'Small hydro' => 'hydro_small',
      'Coal' => 'fossil_hard_coal',
      'Nuclear' => 'nuclear',
      'Natural Gas' => 'fossil_gas',
      'Large Hydro' => 'hydro_large',
      'Batteries' => 'battery',
      'Imports' => 'import',
      'Other' => 'other',
    }
    FUEL_KEYS = FUELS.keys
    FUEL_VALUES = FUELS.values

    def initialize
      super
      @r_gen = []
      @r_trans = []
    end

    URL_FORMAT = "https://www.caiso.com/outlook/history/%Y%m%d/fuelsource.csv"

    def add_buffer(body)
      csv = FastestCSV.parse(body, row_sep: "\r\n")
      @fields = csv.shift

      # Handle empty data
      raise EmptyError if @fields.empty? || @fields.first.to_s.strip == '' || @fields.first == "\n"

      from_area_id = Area.where(source: self.class.source_id, code: 'CAISO').pluck(:id).first
      to_area_id = Area.where(source: self.class.source_id, code: 'other').pluck(:id).first

      raise @fields.inspect unless @fields.map(&:downcase) == FUEL_KEYS.map(&:downcase)
      last_time = @from
      csv.each do |row|
        next if row[1..].compact.blank?
        time = parse_time(row)
        next if time < last_time
        last_time = time

        row.each_with_index do |value, i|
          next if i == 0
          raise i.to_s unless FUEL_VALUES[i]
          production_type = FUEL_VALUES[i]
          value = (value.to_f*1000).to_i
          if production_type == 'import'
            @r_trans << {
              time:,
              from_area_id:,
              to_area_id:,
              value:
            }
          else
            @r_gen << {
              time:,
              production_type:,
              value:,
              country: 'CAISO'
            }
          end
        end
      end

      self
    end

    def done!
      return if @r_gen.empty? && @r_trans.empty?

      r_gen = Validate.validate_generation(@r_gen, self.class.source_id)
      ::Out::Generation.run(r_gen, @from, @to, self.class.source_id)
      ::Out::Transmission.run(@r_trans, @from, @to, self.class.source_id)

      super
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    FIELDS = ["Time", "Hour ahead forecast", "Current demand", "Net demand"]

    def self.each
      from = ::Load.joins(:area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield date
      end
    end

    def initialize
      super
      @r_load = []
    end

    URL_FORMAT = "https://www.caiso.com/outlook/history/%Y%m%d/netdemand.csv"

    def add_buffer(body)
      csv = FastestCSV.parse(body, row_sep: "\r\n")
      @fields = csv.shift

      # Handle empty data
      raise EmptyError if @fields.empty? || @fields.first.to_s.strip == '' || @fields.first == "\n"

      raise @fields.inspect unless @fields[0..3].map(&:downcase) == FIELDS.map(&:downcase)
      last_time = @from
      csv.each do |row|
        next if row[1..].compact.blank?
        time = parse_time(row)
        next if time < last_time
        last_time = time

        value = (row[2].to_f*1000).to_i
        @r_load << {
          time:,
          value:,
          country: 'CAISO'
        }
      end

      self
    end

    def done!
      return if @r_load.empty?

      r_load = Validate::validate_load(@r_load, self.class.source_id)
      Out::Load.run(r_load, @from, @to, self.class.source_id)

      super
    end
  end
end
