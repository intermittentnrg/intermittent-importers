module Out
  module Generation
    def process
      data = points
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"
      areas = {}
      production_types = {}
      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= Area.where(source: self.class.source_id, code: p[:country]).pluck(:id).first) if p[:country]
        p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        p.delete :production_type
        p.delete :country
        p.delete :process_type
      end

      rows=::Generation.where(time: @from...@to).where(area_id: areas.values).order(:time, :production_type_id)
      rows=rows.map { |r| r=r.attributes ; r.delete("created_at") ; r.delete("updated_at") ; r.symbolize_keys }

      diff = data-rows
      if diff
        diff.each do |d|
          logger.warn "new or updated", event: {duration: Time.now-d[:time]}, generation: d
        end
      end
      #data-rows # NEW & UPDATED ROWS
      #rows-data # OLD BAD VALUES
      #require 'pry' ; binding.pry

      ::Generation.upsert_all(data) if data.present?
    end
  end
  module Load
    def process
      area_id = Area.where(source: self.class.source_id, code: @country).pluck(:id).first
      data = points
      logger.info "#{points.length} points"
      data.each do |p|
        p[:area_id] = area_id
        p.delete :country
      end

      rows=::Load.where(time: @from...@to).where(area_id: area_id).order(:time)
      rows=rows.map { |r| r=r.attributes ; r.delete("created_at") ; r.delete("updated_at") ; r.symbolize_keys }

      diff = data-rows
      if diff
        diff.each do |d|
          logger.warn "new or updated", event: {duration: Time.now-d[:time]}, load: d
        end
      end

      #require 'pry' ; binding.pry
      ::Load.upsert_all data
    end
  end
end
