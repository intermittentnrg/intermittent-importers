# frozen_string_literal: true

require 'English'
require 'zip'
require 'fast_jsonparser'

module EiaBulk
  class Base
    def self.source_id
      'eia'
    end

    def self.cli(args)
      if args.empty? || args.length > 2
        warn "#{$PROGRAM_NAME}: <file> [filter]"
        return
      end

      new.add_file(args[0], filter: args[1]).done!
    end

    def add_file(path, filter: nil)
      setup_database

      file = if path =~ /\.zip$/i
               zip_file = Zip::File.open(path)
               zip_file.first.get_input_stream
             else
               File.open(path, 'r')
             end

      conn = ActiveRecord::Base.connection.raw_connection
      enco = PG::TextEncoder::CopyRow.new
      conn.copy_data "COPY #{self.class::BULK_TABLE} FROM STDIN", enco do
        file.each_line do |line|
          next if line[0] == '\r'

          m = line.match(/"series_id":"(.*?)"/)
          next unless m

          series = m[1]
          next if filter && !series.include?(filter)

          process_line(series, line) { |row| conn.put_copy_data(row) }
        end
      end
      self.class.copy_data_from_temp_table

      self
    ensure
      file&.close
      cleanup_database
    end

    def setup_database
      ActiveRecord::Base.connection.create_enum :eia_bulk_area, Area.where(source: 'eia').order(:code).pluck(:code)
    end

    def cleanup_database
      ActiveRecord::Base.connection.drop_table self.class::BULK_TABLE, if_exists: true
      ActiveRecord::Base.connection.drop_enum :eia_bulk_area
    end

    def done!; end

    def parse_time(t)
      "#{t[0, 4]}-#{t[4, 2]}-#{t[6, 5]}:00Z"
    end

    def self.copy_data_from_temp_table
      self::TARGET_MODEL.disable_compression_policy!
      self::TARGET_MODEL.chunks.each do |chunk|
        logger.benchmark_info("decompress chunk #{chunk.chunk_name}") do
          chunk.decompress!
        rescue ActiveRecord::StatementInvalid
          raise unless $ERROR_INFO.cause.is_a? PG::DuplicateObject
        end
        logger.benchmark_info("INSERT SELECT BETWEEN #{chunk.range_start} AND #{chunk.range_end}") do
          ActiveRecord::Base.connection.execute copy_sql(chunk.range_start, chunk.range_end)
        end
      end
      self::TARGET_MODEL.enable_compression_policy!
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    V_USA = Eia::Generation::VALIDATION_GEN
    V_USA_ALL = V_USA['all']
    BULK_TABLE = 'eia_bulk_generation'
    TARGET_MODEL = ::Generation

    def setup_database
      super
      ActiveRecord::Base.connection.create_enum :eia_bulk_production_type,
                                                %w[fossil_gas fossil_hard_coal fossil_oil hydro nuclear other solar
                                                   wind unknown]
      ActiveRecord::Base.connection.create_table BULK_TABLE, id: false, temporary: true do |t|
        t.timestamptz :time, null: false
        t.column :area, :eia_bulk_area, null: false
        t.column :production_type, :eia_bulk_production_type, null: false
        t.integer :value, null: false
      end
    end

    def cleanup_database
      super
      ActiveRecord::Base.connection.drop_enum :eia_bulk_production_type
    end

    def process_line(series, line)
      # series is the full series_id string (e.g., "EBA.CISO-ALL.NG.SUN.H")
      parts = series.split(/\./)
      # 0   1        2  3   4
      # EBA.US48-ALL.NG.H
      # EBA.CISO-ALL.NG.SUN.H
      return unless parts.length == 5 # skip generation without fuel type
      return unless parts[2] == 'NG' # net generation
      return unless parts[4] == 'H' # timezone

      logger.benchmark_info "series #{series}" do
        json = FastJsonparser.parse(line, symbolize_keys: false)

        country = parts[1].split(/-/)[0]

        production_type = Eia::Base::FUEL_MAP[parts[3]]

        json['data'].each do |p|
          next nil unless p[1]

          time = parse_time(p[0])
          value = (p[1].to_i * 1000)
          v1 = V_USA[country].try(:[], production_type) || {}
          v2 = V_USA_ALL.try(:[], production_type) || {}
          min = v1[:min] || v2[:min]
          max = v1[:max] || v2[:max]
          next unless (min...max).include?(value)

          yield [time, country, production_type, value]
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
  end

  class Demand < Base
    include SemanticLogger::Loggable

    V_USA = Eia::Load::VALIDATION_LOAD
    V_USA_ALL = V_USA['all']
    BULK_TABLE = 'eia_bulk_demand'
    TARGET_MODEL = Load

    def setup_database
      super
      ActiveRecord::Base.connection.create_table BULK_TABLE, id: false, temporary: true do |t|
        t.timestamptz :time, null: false
        t.column :area, :eia_bulk_area, null: false
        t.integer :value, null: false
      end
    end

    def process_line(series, line)
      # series is the full series_id string (e.g., "EBA.CISO-ALL.D.H")
      # 0   1      2 3
      # EBA.SW-ALL.D.H
      parts = series.split(/\./)
      return unless parts[2] == 'D'
      return unless parts[3] == 'H'

      country, country_suffix = parts[1].split(/-/)
      return if country_suffix != 'ALL'

      logger.benchmark_info "series #{series}" do
        json = FastJsonparser.parse(line, symbolize_keys: false)
        json['data'].each do |p|
          next nil unless p[1]

          value = (p[1].to_i * 1000)
          time = parse_time(p[0])

          v1 = V_USA[country].try(:[], 'load') || {}
          v2 = V_USA_ALL.try(:[], 'load') || {}
          min = v1[:min] || v2[:min]
          max = v1[:max] || v2[:max]
          next unless (min...max).include?(value)

          yield [time, country, value]
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

    BULK_TABLE = 'eia_bulk_interchange'
    TARGET_MODEL = Transmission

    def setup_database
      super
      ActiveRecord::Base.connection.create_table BULK_TABLE, id: false, temporary: true do |t|
        t.timestamptz :time, null: false
        t.column :from_area, :eia_bulk_area, null: false
        t.column :to_area, :eia_bulk_area, null: false
        t.integer :value, null: false
      end
    end

    def process_line(series, line)
      # series is the full series_id string (e.g., "EBA.CISO-AZPS.ID.H")
      # 0   1         2  3
      # EBA.CISO-AZPS.ID.H
      parts = series.split(/\./)
      return unless parts[2] == 'ID'
      return unless parts[3] == 'H'
      raise series.inspect unless parts.length == 4

      from_area, to_area = parts[1].split(/-/)

      logger.benchmark_info "series #{series}" do
        json = FastJsonparser.parse(line, symbolize_keys: false)

        json['data'].each do |p|
          next nil unless p[1]

          time = parse_time(p[0])
          # invert value. export need to be measured as drain on from_area, but EIA measures output to to_area
          value = -(p[1].to_i * 1000)
          value = [value, -2_147_483_648].max
          value = [value, 2_147_483_647].min

          yield [time, from_area, to_area, value]
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
