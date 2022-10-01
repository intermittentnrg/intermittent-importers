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
    @out_model.parsers_each(@source, &block)
  end

  def run
    pass = false
    areas = {}
    production_types = {}
    parsers_each do |e|
      data = e.points
      #require 'pry' ;binding.pry
      @@logger.info "#{data.length} points"

      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= Area.where(source: @source.source_id, code: p[:country]).pluck(:id).first) if p[:country]
        p[:from_area_id] = (areas[p[:from_area]] ||= Area.where(source: @source.source_id, code: p[:from_area]).pluck(:id).first) if p[:from_area]
        p[:to_area_id] = (areas[p[:to_area]] ||= Area.where(source: @source.source_id, code: p[:to_area]).pluck(:id).first) if p[:to_area]
        p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
        #require 'pry' ;binding.pry
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

class Pump::NordpoolPrice < Pump
  def parsers_each(&block)
    from = Price.joins(:area).group(:'area.code').where("time > ?", 6.month.ago).where(area: {source: @source.source_id}).pluck(Arel.sql("LAST(time, time)")).min.to_datetime
    from = from.next_day.beginning_of_day
    to = 2.days.from_now
    #require 'pry' ; binding.pry
    (from..to).each do |date|
      yield @source.new date
    end
  end
end
class Pump::NordpoolTransmission < Pump
  def parsers_each(&block)
    from = Transmission.joins(:from_area).group(:'from_area.code').where('value IS NOT NULL').where(from_area: {source: @source.source_id}).pluck(Arel.sql("LAST(time, time)")).min.try(:to_datetime).try(:next_day)
    from ||= Date.parse("2021-10-01")
    to = 2.days.from_now
    (from..to).each do |date|
      #require 'pry' ; binding.pry
      yield Nordpool::Transmission.new(date)
    end
  end
end
class Pump::NordpoolCapacity < Pump
  def parsers_each(&block)
    from = Transmission.joins(:from_area).group(:'from_area.code').where('capacity IS NOT NULL').where(from_area: {source: @source.source_id}).pluck(Arel.sql("LAST(time, time)")).min.try(:to_datetime).try(:next_day)
    from ||= Date.parse("2021-10-01")
    to = 2.days.from_now
    (from..to).each do |date|
      #require 'pry' ; binding.pry
      yield Nordpool::Capacity.new(date)
    end
  end
end
