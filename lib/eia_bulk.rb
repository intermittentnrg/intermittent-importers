require 'zip'
require 'fast_jsonparser'

module EiaBulk
  class Base
    def self.source_id
      "eia"
    end

    def self.cli(args)
      unless args.length == 1
        $stderr.puts "#{$0}: <file>"
        return
      end

      new(*args).process
    end

    def initialize(path, filter=nil)
      if path =~ /\.zip$/i
        zip_file = Zip::File.open(path)
        @file = zip_file.first.get_input_stream
      else
        @file = File.open(path, 'r')
      end
      @filter = filter

      super()

      ActiveRecord::Base.connection.create_enum :eia_bulk_area, Area.where(source:'eia').order(:code).pluck(:code)
    end

    def parse_time(t)
      "#{t[0,4]}-#{t[4,2]}-#{t[6,5]}:00Z"
    end

    def process
      conn = ActiveRecord::Base.connection.raw_connection
      enco = PG::TextEncoder::CopyRow.new
      conn.copy_data "COPY #{self.class::BULK_TABLE} FROM STDIN", enco do
        @file.each_line do |line|
          next if line[0] == '\r'
          m = line.match(/"series_id":"(.*?)"/)
          next unless m
          @series = m[1]
          process_line(line) { |row| conn.put_copy_data(row) }
        end
      end
      self.class.copy
    end

    def self.copy
      self::TARGET_MODEL.disable_compression_policy!
      ranges = ActiveRecord::Base.connection.select_rows("SELECT range_start,range_end,chunk_name FROM timescaledb_information.chunks WHERE hypertable_schema='intermittency' AND hypertable_name='#{self::TARGET_MODEL.table_name}' ORDER BY range_start DESC")
      ranges.each do |range_start, range_end, chunk_name|
        logger.benchmark_info("decompress chunk #{chunk_name}") do
        ActiveRecord::Base.connection.execute("SELECT decompress_chunk('_timescaledb_internal.#{chunk_name}')");
        rescue ActiveRecord::StatementInvalid
          raise unless $!.cause.is_a? PG::DuplicateObject
        end
        logger.benchmark_info("INSERT SELECT BETWEEN #{range_start} AND #{range_end}")  do
          ActiveRecord::Base.connection.execute copy_sql(range_start, range_end)
        end
      end
      self::TARGET_MODEL.enable_compression_policy!
      ActiveRecord::Base.connection.drop_table self::BULK_TABLE
      copy_cleanup
    end

    def self.copy_cleanup
      ActiveRecord::Base.connection.drop_enum :eia_bulk_area
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    V_USA = Validate::RULES['usa']
    V_USA_ALL = V_USA['all']
    BULK_TABLE = "eia_bulk_generation"
    TARGET_MODEL = ::Generation

    def initialize(args)
      super
      ActiveRecord::Base.connection.create_enum :eia_bulk_production_type, %w[fossil_gas fossil_hard_coal fossil_oil hydro nuclear other solar wind unknown]
      ActiveRecord::Base.connection.create_table BULK_TABLE, id: false, temporary: true do |t|
        t.timestamptz :time, null: false
        t.column :area, :eia_bulk_area, null: false
        t.column :production_type, :eia_bulk_production_type, null: false
        t.integer :value, null: false
      end
    end

    def process_line(line)
      series = @series.split /\./
      # 0   1        2  3   4
      # EBA.US48-ALL.NG.H
      # EBA.CISO-ALL.NG.SUN.H
      return unless series.length == 5 #skip generation without fuel type
      return unless series[2] == 'NG' # net generation
      return unless series[4] == 'H' #timezone

      logger.benchmark_info "series #{@series}" do
        json = FastJsonparser.parse(line, symbolize_keys: false)

        country = series[1].split(/-/)[0]

        production_type = Eia::Base::FUEL_MAP[series[3]]

        r = json['data'].each do |p|
          next nil unless p[1]
          time = parse_time(p[0])
          value = (p[1]*1000).to_i
          v1 = V_USA[country].try(:[], production_type) || {}
          v2 = V_USA_ALL.try(:[], production_type) || {}
          min = v1[:min]||v2[:min]
          max = v1[:max]||v2[:max]
          next unless (min...max).include?(value)

          yield [time,country,production_type,value]
        end
      end
    end

    def self.copy_sql(range_start, range_end)
      <<~SQL
        INSERT INTO generation_data (areas_production_type_id, time, value)
        SELECT apt.id,time-INTERVAL '1 hour' AS time,value FROM #{BULK_TABLE} ebg
        LEFT JOIN areas a ON(ebg.area::text=a.code AND a.source='eia')
        LEFT JOIN production_types pt ON(ebg.production_type::text=pt.name)
        LEFT JOIN areas_production_types apt ON(a.id=apt.area_id AND pt.id=apt.production_type_id)
        WHERE time BETWEEN '#{range_start}'::timestamptz + INTERVAL '1 hour' AND '#{range_end}'::timestamptz + INTERVAL '1 hour'
        ON CONFLICT ON CONSTRAINT generation_pkey DO UPDATE SET value = EXCLUDED.value WHERE generation_data.value<>EXCLUDED.value
      SQL
    end

    def self.copy_cleanup
      ActiveRecord::Base.connection.drop_enum :eia_bulk_production_type
      super
    end
  end

  class Demand < Base
    include SemanticLogger::Loggable

    V_USA = Validate::RULES['usa']
    V_USA_ALL = V_USA['all']
    BULK_TABLE = "eia_bulk_demand"
    TARGET_MODEL = Load

    def initialize(args)
      super
      ActiveRecord::Base.connection.create_table BULK_TABLE, id: false, temporary: true do |t|
        t.timestamptz :time, null: false
        t.column :area, :eia_bulk_area, null: false
        t.integer :value, null: false
      end
    end

    def process_line(line)
      # 0   1      2 3
      # EBA.SW-ALL.D.H
      series = @series.split /\./
      return unless series[2] == 'D'
      return unless series[3] == 'H'
      country, country_suffix = series[1].split(/-/)
      return if country_suffix != 'ALL'

      logger.benchmark_info "series #{@series}" do
        json = FastJsonparser.parse(line, symbolize_keys: false)
        r = json['data'].each do |p|
          next nil unless p[1]
          value = (p[1]*1000).to_i
          time = parse_time(p[0])

          v1 = V_USA[country].try(:[], 'load') || {}
          v2 = V_USA_ALL.try(:[], 'load') || {}
          min = v1[:min]||v2[:min]
          max = v1[:max]||v2[:max]
          next unless (min...max).include?(value)

          yield [time,country,value]
        end
      end
    end

    def self.copy_sql(range_start, range_end)
      <<~SQL
        INSERT INTO load (area_id, time, value)
        SELECT a.id,time-INTERVAL '1 hour' AS time,value FROM #{BULK_TABLE} ebl
        LEFT JOIN areas a ON(ebl.area::text=a.code AND a.source='eia')
        WHERE time BETWEEN '#{range_start}'::timestamptz + INTERVAL '1 hour' AND '#{range_end}'::timestamptz + INTERVAL '1 hour'
        ON CONFLICT ON CONSTRAINT load_pkey DO UPDATE SET value = EXCLUDED.value WHERE load.value<>EXCLUDED.value
      SQL
    end
  end

  class Interchange < Base
    include SemanticLogger::Loggable

    BULK_TABLE = "eia_bulk_interchange"
    TARGET_MODEL = Transmission

    def initialize(args)
      super
      ActiveRecord::Base.connection.create_table BULK_TABLE, id: false, temporary: true do |t|
        t.timestamptz :time, null: false
        t.column :from_area, :eia_bulk_area, null: false
        t.column :to_area, :eia_bulk_area, null: false
        t.integer :value, null: false
      end
    end

    def process_line(line)
      # 0   1         2  3
      # EBA.CISO-AZPS.ID.H
      series = @series.split /\./
      return unless series[2] == 'ID'
      return unless series[3] == 'H'
      raise series.inspect unless series.length == 4
      from_area, to_area = series[1].split(/-/)

      logger.benchmark_info "series #{@series}" do
        json = FastJsonparser.parse(line, symbolize_keys: false)

        #from, to = parse_from_to(json)

        r = json['data'].each do |p|
          next nil unless p[1]
          time = parse_time(p[0])
          # invert value. export need to be measured as drain on from_area, but EIA measures output to to_area
          value = -(p[1]*1000).to_i
          value = [value, -2147483648].max
          value = [value, 2147483647].min

          yield [time,from_area,to_area,value]
        end
      end
    end

    def self.copy_sql(range_start, range_end)
      <<~SQL
        INSERT INTO transmission (from_area_id, to_area_id, time, value)
        SELECT from_area.id,to_area.id,time-INTERVAL '1 hour' AS time,value FROM #{BULK_TABLE} ebi
        LEFT JOIN areas from_area ON(ebi.from_area::text=from_area.code AND from_area.source='eia')
        LEFT JOIN areas to_area ON(ebi.to_area::text=to_area.code AND from_area.source='eia')
        WHERE time BETWEEN '#{range_start}'::timestamptz + INTERVAL '1 hour' AND '#{range_end}'::timestamptz + INTERVAL '1 hour'
        ON CONFLICT ON CONSTRAINT transmission_pkey DO UPDATE SET value = EXCLUDED.value WHERE transmission.value<>EXCLUDED.value
      SQL
    end
  end
end
