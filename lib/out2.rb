module Out2
  WQ = ::WorkQueue.new(1, 3)
  at_exit do
    WQ.join
  end

  class Generation
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
        rows=::Generation.where(time: from...to).where(area_id: areas.values).order(:time, :production_type_id)
        rows=rows.map { |r| r.attributes.symbolize_keys }

        index = Hash[rows.map { |r| [[r[:time], r[:production_type_id]], r] }]
        data.each do |p|
          old = index[[p[:time], p[:production_type_id]]]
          if old && old[:value] != p[:value]
            logger.warn "updated", event: {duration: Time.now-p[:time]}, generation: p
          end
        end
      end

      if data.present?
        WQ.enqueue_b do
          logger.benchmark_info("upsert") do
            #require 'pry' ; binding.pry
            ::Generation.upsert_all(data)
          end
        end
      end
    end
  end

  class Load
    include SemanticLogger::Loggable

    def self.run(data, from, to, source_id)
      raise unless data
      raise unless from && to
      areas = {}
      logger.info "#{data.length} points"
      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= ::Area.where(source: source_id, code: p[:country]).pluck(:id).first) if p[:country]
        p.delete :country
      end

      logger.benchmark_info("diff calculation") do
        rows=::Load.where(time: from...to).where(area_id: areas.values).order(:time)
        rows=rows.map { |r| r.attributes.symbolize_keys }

        index = Hash[rows.map { |r| [r[:time], r] }]
        data.each do |p|
          old = index[p[:time]]
          if old && old[:value] != p[:value]
            logger.warn "updated", event: {duration: Time.now-p[:time]}, load: p
          end
        end
        #require 'pry' ; binding.pry
      end

      if data.present?
        WQ.enqueue_b do
          logger.benchmark_info("upsert") do
            ::Load.upsert_all data if data.present?
          end
        end
      end
    end
  end
end
