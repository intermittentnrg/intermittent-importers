module Out2
  class Base
  end

  class Generation < Base
    include SemanticLogger::Loggable

    @@apts = {}
    def self.run(data, from, to, source_id)
      raise unless data
      raise unless from && to
      data.each do |p|
        raise :area_id if p[:area_id]
        raise :production_type_id if p[:production_type_id]
        k = [source_id, p[:country], p[:production_type]]
        apt_id = @@apts[k] ||= AreasProductionType.joins(:source_area, :production_type).where(source_area: {source: source_id, internal_id: p[:country]}, production_type: {name: p[:production_type]}).pluck(:id).first
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
        if data.length > 100_000
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
          r = ::Generation.upsert_all(data, on_duplicate: Arel.sql('value = EXCLUDED.value WHERE (generation_data.*) IS DISTINCT FROM (EXCLUDED.*)'))
          updated_rows = r.try(:length).to_i
        end
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{updated_rows} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end

      updated_rows
    end
  end

  class Unit < Base
    include SemanticLogger::Loggable

    @@units = {}
    def self.run(data, from, to, source_id)
      raise unless from && to
      updated_rows = nil
      if data.present?

        data.each do |p|
          if p[:country] && p[:unit] && p[:production_type]
            k = [source_id, p[:production_type], p[:unit]]
            p[:unit_id] = (@@units[k] ||= ::Unit.joins(:production_type, :area).where(internal_id: p[:unit], area: {source: source_id, code: p[:country]}, production_type: {name: p[:production_type]}).pluck(:id).first)
            unless p[:unit_id]
              require 'pry' ; binding.pry
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
        #require 'pry' ; binding.pry

        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        if data.length > 100_000
          begin
            #GenerationUnit.disable_compression_policy!
            #GenerationUnit.hypertable.chunks.where(range_start: ..to, range_end: from..).each &:decompress!

            conn = ActiveRecord::Base.connection
            tmptable = "generation_unit_copy_#{source_id}"
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
              FROM #{tmptable} g
              WHERE NOT EXISTS (
                    SELECT 1 FROM generation_unit g2
                    WHERE g.unit_id=g2.unit_id AND g.time=g2.time AND g.value=g2.value AND
                          time BETWEEN (SELECT MIN(time) FROM #{tmptable}) AND (SELECT MAX(time) FROM #{tmptable})
              )
              ON CONFLICT (unit_id, time)
                DO UPDATE set value = EXCLUDED.value
            SQL
            updated_rows = r.cmd_tuples
            conn.drop_table tmptable
          ensure
            #GenerationUnit.enable_compression_policy!
          end
        else
          data.each_slice(1_000_000) do |data2|
            r = ::GenerationUnit.upsert_all(data2)
          end
          updated_rows = r.try(:length).to_i
        end
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{updated_rows} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end
    end
  end
  class UnitHires
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      if data.present?
        logger.benchmark_info("upsert") do
          data.each_slice(1_000_000) do |data2|
            ::GenerationUnitHires.upsert_all(data2)
          end
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
        p[:area_id] = (@@areas[k] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        p.delete :country
      end

      r = nil
      if data.present?
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        r = ::Load.upsert_all data
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end
    end
  end

  class Price < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      #raise unless from && to
      areas = {}

      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        unless p[:area_id]
          require 'pry' ; binding.pry
        end
        p.delete :country
      end

      r = nil
      if data.present?
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        r = ::Price.upsert_all(data)
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end
    end
  end

  class Capacity
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      areas = {}
      production_types = {}
      data.each do |p|
        area = areas[p[:area_id]] ||= Area.find(p[:area_id])
        p[:production_type_id] = (production_types[p[:production_type]] ||= ::ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        p[:areas_production_type_id] = area.areas_production_type.where(production_type_id: p[:production_type_id]).pluck(:id).first
        p.delete :production_type
      end

      r = nil
      if data.present?
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        r = ::Capacity.upsert_all(data)
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end
    end
  end

  class UnitCapacity
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      r = nil
      if data.present?
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        data.each_slice(100_000) do |data2|
          r = GenerationUnitCapacity.upsert_all(data2)
        end
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end
    end
  end

  class Transmission
    include SemanticLogger::Loggable

    @@areas = {}
    @@aas = {}
    def self.run(data, from, to, source_id)
      #raise unless @from && @to
      #require 'pry' ;binding.pry

      data.each do |p|
        kfrom = [source_id, p[:from_area]]
        kto = [source_id, p[:to_area]]
        p[:from_area_id] ||= (@@areas[kfrom] ||= ::Area.where(source: source_id, code: p[:from_area]).pluck(:id).first)
        p[:to_area_id] ||= (@@areas[kto] ||= ::Area.where(source: source_id, code: p[:to_area]).pluck(:id).first)
        kaa = [source_id, p[:from_area_id], p[:to_area_id]]
        p[:areas_area_id] ||= (@@aas[kaa] ||= ::AreasArea.where(
                                 from_area_id: p[:from_area_id],
                                 to_area_id: p[:to_area_id]
                               ).pluck(:id).first)
        unless p[:areas_area_id]
          logger.error("Missing AreasArea #{p.inspect}")
        #   a = ::Area.create!(source: source_id, code: p[:to_area], type: 'country', region: nil, enabled: false)
        #   p[:to_area_id] = areas[p[:to_area]] = a.id
        end
        p.delete :from_area
        p.delete :from_area_id
        p.delete :to_area
        p.delete :to_area_id
      end

      r = nil
      if data.present?
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        r = ::Transmission.upsert_all(data, on_duplicate: Arel.sql('value = EXCLUDED.value WHERE (transmission_data.*) IS DISTINCT FROM (EXCLUDED.*)'))
        duration = 1_000.0 * (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start)
        logger.measure_info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}", duration:)
      end
    end
  end
end
