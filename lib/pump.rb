class Pump
  @@logger = SemanticLogger[Pump]

  def initialize(source, out_model)
    @source = source
    @out_model = out_model
  end

  def run_loop
    pass = false
    loop do
      pass = run_all
      break unless pass
      $stderr.puts "===== LOOP ====="
    end
  end

  def parsers_each(&block)
    @source.parsers_each(&block)
  end

  def run
    pass = false
    areas = {}
    production_types = {}
    parsers_each do |e|
      data = e.points
      #require 'pry' ;binding.pry
      @@logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= Area.where(source: @source.source_id, code: p[:country]).pluck(:id).first) if p[:country]
        p[:from_area_id] = (areas[p[:from_area]] ||= Area.where(source: @source.source_id, code: p[:from_area]).pluck(:id).first) if p[:from_area]
        p[:to_area_id] = (areas[p[:to_area]] ||= Area.where(source: @source.source_id, code: p[:to_area]).pluck(:id).first) if p[:to_area]
        p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        #require 'pry' ;binding.pry
        p.delete :production_type
        p.delete :country
        p.delete :from_area
        p.delete :to_area
        p.delete :process_type
      end

      @out_model.upsert_all(data) if data.present?
      #pass if e.last_time > from
    rescue ENTSOE::EmptyError
      raise if to < 1.day.ago # raise if within 24hrs

      @@logger.warn "skipped missing data until #{to}"
    end

    pass
  end
end

class Pump::Process < Pump
  def run
    parsers_each do |e|
      e.process
    rescue ENTSOE::EmptyError
      @@logger.warn "empty response", $!
    end
  end
end
