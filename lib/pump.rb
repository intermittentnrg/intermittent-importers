require './app/models/area'

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

  def run
    pass = false
    areas = {}
    #@source::COUNTRIES.keys.each do |country|
    @out_model.parsers_each(@source) do |e|
      data = e.points
      #require 'pry' ;binding.pry
      @@logger.info "#{data.length} points"

      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= Area.where(source: @source.source_id, code: p[:country]).pluck(:id).first)
        #require 'pry' ;binding.pry
        p.delete :country
        p.delete :process_type
      end

      @out_model.insert_all(data) if data.present?
      #pass if e.last_time > from
    rescue ENTSOE::EmptyError
      raise if to < 1.day.ago # raise if within 24hrs

      @@logger.warn "skipped missing data until #{to}"
    end

    pass
  end
end
