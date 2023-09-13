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

      logger.benchmark_info("diff calculation") do
        index = ::Generation.where(time: from...to).where(area_id: areas.values).as_json
        index = Hash[index.map do |r|
          r.symbolize_keys!

          [[r[:time], r[:production_type_id]], r]
        end]
        data.each do |p|
          old = index[[p[:time], p[:production_type_id]]]
          if old && old[:value] != p[:value]
            logger.warn "updated", event: {duration: Time.now-p[:time]}, generation: p
          end
        end
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

      if from && to && areas.present?
        logger.benchmark_info("diff calculation") do
          index = ::Load.where(time: from...to).where(area_id: areas.values).as_json
          index = Hash[index.map do |r|
                         r.symbolize_keys!

                         [r[:time], r]
                       end]
          data.each do |p|
            old = index[p[:time]]
            if old && old[:value] != p[:value]
              logger.warn "updated", event: {duration: Time.now-p[:time]}, load: p
            end
          end
          #require 'pry' ; binding.pry
        end
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

      if from && to && areas.present?
        logger.benchmark_info("diff calculation") do
          rows=::Price.where(time: from...to).where(area_id: areas.values).order(:time)
          rows=rows.map { |r| r.attributes.symbolize_keys }
          index = Hash[rows.map { |r| [[r[:area_id], r[:time]], r] }]
          data.each do |p|
            k = [p[:area_id], p[:time]]
            old = index[k]
            if old && old[:value] != p[:value]
              logger.warn "updated #{old[:value]} > #{p[:value]}", event: {duration: Time.now-p[:time]}, price: p
              #elsif old
              #  logger.info "good"
            end
          end
        end
      end
      #require 'pry' ; binding.pry

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
