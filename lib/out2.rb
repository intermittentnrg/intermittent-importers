module Out2
  WQ = ::WorkQueue.new(1, 3)
  at_exit do
    WQ.join
  end

  class Base
    if Rails.env.test?
      def self.enqueue(&block)
        block.call
      end
    else
      def self.enqueue(&block)
        WQ.enqueue_b(&block)
      end
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      raise unless data
      raise unless from && to
      logger.info "#{from} #{data.length} points"
      areas = {}
      production_types = {}
      data.each do |p|
        p[:area_id] ||= (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        raise p.inspect unless p[:area_id]
        p[:production_type_id] = (production_types[p[:production_type]] ||= ::ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        p.delete :production_type
        p.delete :country
      end

      if data.present?
        enqueue do
          logger.benchmark_info("upsert") do
            #require 'pry' ; binding.pry
            ::Generation.upsert_all(data)
          end
        end
      end
    end
  end

  class Unit < Base
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      unless data.present?
        require 'pry' ; binding.pry
      end
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
        enqueue do
          logger.benchmark_info("upsert") do
            ::Load.upsert_all data if data.present?
          end
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
        enqueue do
          logger.benchmark_info("upsert") do
            ::Price.upsert_all(data) if data.present?
          end
        end
      end
    end
  end
end
