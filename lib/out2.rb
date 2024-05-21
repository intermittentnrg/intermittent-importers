module Out2
  class Base
  end

  class Generation < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      raise unless data
      raise unless from && to
      logger.info "#{from} #{data.length} points"
      areas = {}
      production_types = {}
      apts = {}
      data.each do |p|
        area_id = p.delete(:area_id)
        area_id ||= (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        raise p.inspect unless area_id
        pt_id = (production_types[p[:production_type]] ||= ::ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        unless pt_id
          raise p.inspect
        end
        apt_id = apts[[area_id, pt_id]] ||= AreasProductionType.where(source_area_id: area_id, production_type_id: pt_id).pluck(:id).first
        unless apt_id
          logger.warn("no apt_id for area_id #{area_id} pt_id #{pt_id}")
          apt = AreasProductionType.create!(area_id:, source_area_id: area_id, production_type_id: pt_id)
          apts[[area_id, pt_id]] = apt_id = apt.id
        end
        p[:areas_production_type_id] = apt_id
        p.delete :production_type
        p.delete :country
      end

      updated_rows = nil
      if data.present?
        logger.benchmark_info("upsert") do
          if data.length > 100_000
            conn = ActiveRecord::Base.connection
            conn.create_table "generation_copy", id: false, temporary: true do |t|
              t.integer :areas_production_type_id, limit: 2, null: false
              t.timestamptz :time, null: false
              t.integer :value, null: false
            end

            raw_conn = conn.raw_connection
            enco = PG::TextEncoder::CopyRow.new
            raw_conn.copy_data "COPY generation_copy FROM STDIN", enco do
              data.each do |row|
                raw_conn.put_copy_data([row[:areas_production_type_id], row[:time], row[:value]])
              end
            end
            r = conn.execute <<~SQL
              INSERT INTO generation_data (areas_production_type_id, time, value)
              SELECT areas_production_type_id, time, value
              FROM generation_copy g
              WHERE NOT EXISTS (
                    SELECT 1 FROM generation_data g2
                    WHERE g.areas_production_type_id=g2.areas_production_type_id AND g.time=g2.time AND g.value=g2.value AND
                          time BETWEEN (SELECT MIN(time) FROM generation_copy) AND (SELECT MAX(time) FROM generation_copy)
              )
              ON CONFLICT (areas_production_type_id, time)
                DO UPDATE set value = EXCLUDED.value
            SQL
            #WHERE generation_data.value<>EXCLUDED.value
            #binding.irb
            updated_rows = r.cmd_tuples
            conn.execute "DROP TABLE generation_copy"
          else
            r = ::Generation.upsert_all(data, on_duplicate: Arel.sql('value = EXCLUDED.value WHERE (generation_data.*) IS DISTINCT FROM (EXCLUDED.*)'))
            updated_rows = r.try(:length).to_i
          end
        end
        logger.info("updated #{updated_rows} out of #{data.length} rows for range #{from} - #{to}")
      end

      updated_rows
    end
  end

  class Unit < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      updated_rows = nil
      if data.present?
        logger.benchmark_info("upsert") do
          if data.length > 100_000
            conn = ActiveRecord::Base.connection
            conn.create_table "generation_unit_copy", id: false, temporary: false do |t|
              t.integer :unit_id, limit: 2, null: false
              t.timestamptz :time, null: false
              t.integer :value, null: false
            end

            raw_conn = conn.raw_connection
            enco = PG::TextEncoder::CopyRow.new
            raw_conn.copy_data "COPY generation_unit_copy FROM STDIN", enco do
              data.each do |row|
                raw_conn.put_copy_data([row[:unit_id], row[:time], row[:value]])
              end
            end
            r = conn.execute <<~SQL
              INSERT INTO generation_unit (unit_id, time, value)
              SELECT unit_id, time, value
              FROM generation_unit_copy g
              WHERE NOT EXISTS (
                    SELECT 1 FROM generation_unit g2
                    WHERE g.unit_id=g2.unit_id AND g.time=g2.time AND g.value=g2.value AND
                          time BETWEEN (SELECT MIN(time) FROM generation_unit_copy) AND (SELECT MAX(time) FROM generation_unit_copy)
              )
              ON CONFLICT (unit_id, time)
                DO UPDATE set value = EXCLUDED.value
            SQL
            updated_rows = r.cmd_tuples
            conn.execute "DROP TABLE generation_unit_copy"
          else
            data.each_slice(1_000_000) do |data2|
              r = ::GenerationUnit.upsert_all(data2)
            end
            updated_rows = r.try(:length).to_i
          end
        end
        logger.info("updated #{updated_rows} out of #{data.length} rows for range #{from} - #{to}")
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

    def self.run(data, from, to, source_id)
      raise unless data
      logger.info "#{data.length} points"
      areas = {}
      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        p.delete :country
      end

      r = nil
      if data.present?
        logger.benchmark_info("upsert") do
          r = ::Load.upsert_all data
        end
        logger.info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}")
      end
    end
  end

  class Price < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      #raise unless from && to
      areas = {}
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        unless p[:area_id]
          require 'pry' ; binding.pry
        end
        p.delete :country
      end

      r = nil
      if data.present?
        logger.benchmark_info("upsert") do
          r = ::Price.upsert_all(data)
        end
        logger.info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}")
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
        logger.benchmark_info("upsert") do
          r = ::Capacity.upsert_all(data)
        end
        logger.info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}")
      end
    end
  end

  class UnitCapacity
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"
      r = nil
      if data.present?
        logger.benchmark_info("upsert") do
          r = GenerationUnitCapacity.upsert_all(data)
        end
        logger.info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}")
      end
    end
  end

  class Transmission
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      #raise unless @from && @to
      areas = {}
      #require 'pry' ;binding.pry
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      data.each do |p|
        p[:from_area_id] ||= (areas[p[:from_area]] ||= ::Area.where(source: source_id, code: p[:from_area]).pluck(:id).first)
        p[:to_area_id] ||= (areas[p[:to_area]] ||= ::Area.where(source: source_id, code: p[:to_area]).pluck(:id).first)
        # unless p[:to_area_id] && p[:to_area]
        #   logger.warn("Creating area #{p[:to_area]}")
        #   a = ::Area.create!(source: source_id, code: p[:to_area], type: 'country', region: nil, enabled: false)
        #   p[:to_area_id] = areas[p[:to_area]] = a.id
        # end
        p.delete :from_area
        p.delete :to_area
      end

      r = nil
      if data.present?
        logger.benchmark_info("upsert") do
          r = ::Transmission.upsert_all(data, on_duplicate: Arel.sql('value = EXCLUDED.value WHERE (transmission.*) IS DISTINCT FROM (EXCLUDED.*)'))
        end
        logger.info("updated #{r.try :length} out of #{data.length} rows for range #{from} - #{to}")
      end
    end
  end
end
