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
        area_id ||= (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        raise p.inspect unless area_id
        pt_id = (production_types[p[:production_type]] ||= ::ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        apt_id = apts[[area_id, pt_id]] ||= AreasProductionType.where(area_id:, production_type_id: pt_id).pluck(:id).first
        p[:area_id] = area_id
        p[:production_type_id] = pt_id
        p[:areas_production_types_id] = apt_id
        p.delete :production_type
        p.delete :country
      end

      if data.present?
        logger.benchmark_info("upsert") do
          #require 'pry' ; binding.pry
          ::Generation.upsert_all(data)
        end
      end
    end
  end

  class Unit < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      if data.present?
        logger.benchmark_info("upsert") do
          data.each_slice(1_000_000) do |data2|
            ::GenerationUnit.upsert_all(data2)
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

      if data.present?
        logger.benchmark_info("upsert") do
          ::Load.upsert_all data
        end
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

      if data.present?
        logger.benchmark_info("upsert") do
          ::Price.upsert_all(data)
        end
      end
    end
  end

  class Capacity
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      production_types = {}
      data.each do |p|
        p[:production_type_id] = (production_types[p[:production_type]] ||= ::ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        p.delete :production_type
      end

      if data.present?
        logger.benchmark_info("upsert") do
          ::Capacity.upsert_all(data)
        end
      end
    end
  end

  class UnitCapacity
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"
      if data.present?
        logger.benchmark_info("upsert") do
          GenerationUnitCapacity.upsert_all(data)
        end
      end
    end
  end
end
