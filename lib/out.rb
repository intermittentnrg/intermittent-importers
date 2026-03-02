# frozen_string_literal: true

require 'zlib'

module Out
  class Base
  end

  class Generation < Base
    include SemanticLogger::Loggable

    @@apts = {}
    def self.run(data, from, to, source_id)
      raise unless data

      # raise unless from && to
      data.each do |p|
        raise :area_id if p[:area_id]
        raise :production_type_id if p[:production_type_id]

        k = [source_id, p[:country], p[:production_type]]
        apt_id = @@apts[k] ||= AreasProductionType.joins(:source_area, :production_type).where(
          source_area: { source: source_id,
                         internal_id: p[:country] }, production_type: { name: p[:production_type] }
        ).pluck(:id).first
        unless apt_id
          logger.warn("no apt_id for #{p[:country]} pt #{p[:production_type]}")
          area_id = ::Area.where(source: source_id, internal_id: p[:country]).pluck(:id).first
          pt_id = ::ProductionType.where(name: p[:production_type]).pluck(:id).first
          raise p.inspect unless area_id
          raise p.inspect unless pt_id

          apt = AreasProductionType.create!(area_id:, source_area_id: area_id, production_type_id: pt_id)
          @@apts[k] = apt_id = apt.id
        end
        p[:areas_production_type_id] = apt_id
        p.delete :production_type
        p.delete :country
      end

      updated_rows = nil
      if data.present?
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        if data.length >= 100_000
          conn = ActiveRecord::Base.connection
          tmptable = "generation_copy_#{source_id}"
          conn.create_table tmptable, id: false, temporary: true do |t|
            t.integer :areas_production_type_id, limit: 2, null: false
            t.timestamptz :time, null: false
            t.integer :value, null: false
          end

          raw_conn = conn.raw_connection
          enco = PG::TextEncoder::CopyRow.new
          raw_conn.copy_data "COPY #{tmptable} FROM STDIN", enco do
            data.each do |row|
              raw_conn.put_copy_data([row[:areas_production_type_id], row[:time], row[:value].round])
            end
          end
          r = conn.execute <<~SQL
            INSERT INTO generation_data (areas_production_type_id, time, value)
            SELECT areas_production_type_id, time, value
            FROM #{tmptable} g
            WHERE NOT EXISTS (
                  SELECT 1 FROM generation_data g2
                  WHERE g.areas_production_type_id=g2.areas_production_type_id AND g.time=g2.time AND g.value=g2.value AND
                        time BETWEEN (SELECT MIN(time) FROM #{tmptable}) AND (SELECT MAX(time) FROM #{tmptable})
            )
            ON CONFLICT (areas_production_type_id, time)
              DO UPDATE set value = EXCLUDED.value
          SQL
          updated_rows = r.cmd_tuples
          conn.drop_table tmptable
        else
          r = ::Generation.upsert_all(data,
                                      on_duplicate: Arel.sql('value = EXCLUDED.value WHERE (generation_data.*) IS DISTINCT FROM (EXCLUDED.*)'))
          updated_rows = r.try(:length).to_i
        end
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{updated_rows} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end

      updated_rows
    end
  end

  class BaseUnit < Base
    @@units = {}
    def self.preprocess_data(data, source_id)
      data.each do |p|
        next unless p[:country] && p[:unit] && p[:production_type]

        k = [source_id, p[:production_type], p[:unit]]
        p[:unit_id] =
          (@@units[k] ||= ::Unit.joins(:production_type, :area).where(internal_id: p[:unit],
                                                                      area: { source: source_id, code: p[:country] }, production_type: { name: p[:production_type] }).pluck(:id).first)
        unless p[:unit_id]
          logger.warn("creating unit for #{p[:country]}/#{p[:production_type]}/#{p[:unit]}")
          area_id = ::Area.where(source: source_id, code: p[:country]).pluck(:id).first
          pt_id = ::ProductionType.where(name: p[:production_type]).pluck(:id).first
          raise p.inspect unless area_id
          raise p.inspect unless pt_id

          unit = ::Unit.create!(area_id:, production_type_id: pt_id, internal_id: p[:unit])
          @@units[k] = p[:unit_id] = unit.id
        end
        p.delete :country
        p.delete :unit
        p.delete :production_type
      end
    end
  end

  class Unit < BaseUnit
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      return if data.empty?

      # raise unless from && to

      preprocess_data(data, source_id)

      # ENTSO-E: skip unchanged units based on data hash
      # NOTE: Only works when all data for time range is passed (no batching)
      # Set SKIP_FILTER=1 to disable filtering (useful for initial imports)
      if source_id == 'entsoe' && from && to && !ENV['SKIP_FILTER']
        data = logger.benchmark_info('filter_unchanged_units') { filter_unchanged_units(data, source_id, from, to) }
        return if data.empty?
      end

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      conn = ActiveRecord::Base.connection
      tmptable = "generation_unit_copy_#{source_id}_#{start.to_i}"

      begin
        # GenerationUnit.disable_compression_policy!
        # GenerationUnit.hypertable.chunks.where(range_start: ..to, range_end: from..).each &:decompress!

        conn.create_table tmptable, id: false, temporary: true do |t|
          t.integer :unit_id, limit: 2, null: false
          t.timestamptz :time, null: false
          t.integer :value, null: false
        end

        raw_conn = conn.raw_connection
        enco = PG::TextEncoder::CopyRow.new
        raw_conn.copy_data "COPY #{tmptable} FROM STDIN", enco do
          data.each do |row|
            raw_conn.put_copy_data([row[:unit_id], row[:time], row[:value].round])
          end
        end

        r = conn.execute <<~SQL
          INSERT INTO generation_unit (unit_id, time, value)
          SELECT unit_id, time, value
          FROM #{tmptable}
          ON CONFLICT (unit_id, time)
            DO UPDATE SET value = EXCLUDED.value
            WHERE generation_unit.value IS DISTINCT FROM EXCLUDED.value
        SQL

        updated_rows = r.cmd_tuples
      ensure
        # GenerationUnit.enable_compression_policy!
        conn.drop_table(tmptable, if_exists: true)
      end

      duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
      logger.measure_info("updated #{updated_rows} out of #{data.length} rows for range #{from} - #{to}", duration:)
    end

    def self.filter_unchanged_units(data, source_id, from, to)
      return data unless source_id == 'entsoe' && from && to
      return data if data.empty?

      total_rows = data.length

      # Group CSV data by unit and compute row counts
      csv_units = data.group_by { |r| r[:unit_id] }
      csv_row_counts = csv_units.transform_values(&:length)
      csv_unit_ids = csv_units.keys
      total_units = csv_unit_ids.length

      conn = ActiveRecord::Base.connection

      # Phase 1: Quick filter using row counts
      count_sql = <<~SQL
        SELECT unit_id, count(*) as row_count
        FROM generation_unit
        WHERE time BETWEEN '#{from}' AND '#{to}'
        AND unit_id IN (#{csv_unit_ids.join(',')})
        GROUP BY unit_id
      SQL
      db_row_counts = conn.execute(count_sql).each_with_object({}) do |row, h|
        h[row['unit_id'].to_i] = row['row_count'].to_i
      end

      # Units with different row counts are definitely changed
      potentially_unchanged_unit_ids = csv_unit_ids.select do |uid|
        csv_row_counts[uid] == db_row_counts[uid]
      end

      changed_by_count = csv_unit_ids - potentially_unchanged_unit_ids

      # Phase 2: Compute rolling CRC32 using XOR (no string building)
      unit_hashes = {}
      potentially_unchanged_unit_ids.each do |uid|
        rows = csv_units[uid]
        # Compute XOR of individual CRC32s (order-independent, matches SQL bit_xor)
        combined_crc = rows.map do |r|
          Zlib.crc32(format('%.6f:%d', r[:time].to_f, r[:value].to_i))
        end.reduce(0) { |acc, crc| acc ^ crc }
        unit_hashes[uid] = combined_crc
      end

      if potentially_unchanged_unit_ids.any?
        # Use rolling XOR of individual CRC32s instead of string_agg
        # This avoids building large intermediate strings
        hash_sql = <<~SQL
          SELECT unit_id, bit_xor(crc32((extract(epoch from time)::text || ':' || value::text)::bytea)) as hash
          FROM generation_unit
          WHERE time BETWEEN '#{from}' AND '#{to}'
          AND unit_id IN (#{potentially_unchanged_unit_ids.join(',')})
          GROUP BY unit_id
        SQL
        existing_hashes = conn.execute(hash_sql).each_with_object({}) do |row, h|
          h[row['unit_id'].to_i] = row['hash']
        end

        unchanged_by_hash = unit_hashes.select { |uid, h| existing_hashes[uid] == h }.keys
        changed_by_hash = unit_hashes.reject { |uid, h| existing_hashes[uid] == h }.keys
      else
        unchanged_by_hash = []
        changed_by_hash = []
      end

      unchanged_unit_ids = Set.new(unchanged_by_hash)
      changed_unit_ids = Set.new(changed_by_count + changed_by_hash)

      unchanged_rows = data.count { |r| unchanged_unit_ids.include?(r[:unit_id]) }

      logger.info "filter_unchanged_units: #{unchanged_rows}/#{total_rows} rows from #{unchanged_unit_ids.length}/#{total_units} units unchanged"

      return [] if changed_unit_ids.empty?

      data.select { |r| changed_unit_ids.include?(r[:unit_id]) }
    end
  end

  class UnitHires
    include SemanticLogger::Loggable

    def self.run(data, _from, _to, _source_id)
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      return unless data.present?

      logger.benchmark_info('upsert') do
        data.each_slice(1_000_000) do |data2|
          ::GenerationUnitHires.upsert_all(data2)
        end
      end
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    @@areas = {}
    def self.run(data, from, to, source_id)
      raise unless data

      data.each do |p|
        k = [source_id, p[:country]]
        if p[:country]
          p[:area_id] =
            (@@areas[k] ||= ::Area.where(source: source_id, internal_id: p[:country]).pluck(:id).first)
        end
        p.delete :country
      end
      return unless data.present?

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      r = ::Load.upsert_all data
      duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
      logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
    end
  end

  class Price < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      # raise unless from && to
      areas = {}

      data.each do |p|
        if p[:country]
          p[:area_id] =
            (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first)
        end
        unless p[:area_id]
          require 'pry'
          binding.pry
        end
        p.delete :country
      end
      return unless data.present?

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      r = ::Price.upsert_all(data)
      duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
      logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
    end
  end

  class Capacity
    include SemanticLogger::Loggable

    def self.run(data, from, to, _source_id)
      areas = {}
      production_types = {}
      data.each do |p|
        area = areas[p[:area_id]] ||= Area.find(p[:area_id])
        if p[:production_type]
          p[:production_type_id] =
            (production_types[p[:production_type]] ||= ::ProductionType.where(name: p[:production_type]).pluck(:id).first)
        end
        p[:areas_production_type_id] =
          area.areas_production_type.where(production_type_id: p[:production_type_id]).pluck(:id).first
        unless p[:areas_production_type_id]
          logger.error("Missing AreasProductionType #{p.inspect}")
          next
        end
        p.delete :area_id
        p.delete :production_type
        p.delete :production_type_id
      end
      return unless data.present?

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      r = ::Capacity.upsert_all(data)
      duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
      logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
    end
  end

  class UnitCapacity < BaseUnit
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      r = nil

      preprocess_data(data, source_id)

      capacities = {}
      data.delete_if do |p|
        capacity = capacities[p[:unit_id]] ||= GenerationUnitCapacity.where(unit_id: p[:unit_id],
                                                                            time: ..p[:time]).pluck(:value).first

        if capacity != p[:value]
          capacities[p[:unit_id]] = p[:value]

          next false
        end

        true
      end

      return unless data.present?

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      data.each_slice(100_000) do |data2|
        r = GenerationUnitCapacity.upsert_all(data2)
      end
      duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
      logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
    end
  end

  class Transmission
    include SemanticLogger::Loggable

    @@areas = {}
    @@aas = {}
    def self.run(data, from, to, source_id)
      # raise unless @from && @to
      # require 'pry' ;binding.pry

      data.each do |p|
        kfrom = [source_id, p[:from_area]]
        kto = [source_id, p[:to_area]]
        p[:from_area_id] ||= (@@areas[kfrom] ||= ::Area.where(source: source_id, code: p[:from_area]).pluck(:id).first)
        p[:to_area_id] ||= (@@areas[kto] ||= ::Area.where(source: source_id, code: p[:to_area]).pluck(:id).first)
        kaa = [source_id, p[:from_area_id], p[:to_area_id]]
        p[:areas_area_id] ||= @@aas[kaa] ||= ::AreasArea.where(
          from_area_id: p[:from_area_id],
          to_area_id: p[:to_area_id]
        ).pluck(:id).first

        unless p[:areas_area_id]
          logger.warn("Missing AreasArea #{p.inspect}")
          aa = AreasArea.create(from_area_id: p[:from_area_id], to_area_id: p[:to_area_id])
          @@aas[kaa] = p[:areas_area_id] = aa.id
          #   a = ::Area.create!(source: source_id, code: p[:to_area], type: 'country', region: nil, enabled: false)
          #   p[:to_area_id] = areas[p[:to_area]] = a.id
        end
        p.delete :from_area
        p.delete :from_area_id
        p.delete :to_area
        p.delete :to_area_id
      end
      return unless data.present?

      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      r = ::Transmission.upsert_all(data,
                                    on_duplicate: Arel.sql('value = EXCLUDED.value WHERE (transmission_data.*) IS DISTINCT FROM (EXCLUDED.*)'))
      duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
      logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
    end
  end
end
