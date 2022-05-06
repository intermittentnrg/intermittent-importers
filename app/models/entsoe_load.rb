class EntsoeLoad < ActiveRecord::Base
  @@logger = SemanticLogger[EntsoeLoad]
  self.table_name = 'entsoe_load'

  def self.parsers_each(source)
    self.group(:country).where("time > ?", 2.months.ago).pluck(:country, Arel.sql("LAST(time, time)")).each do |country, from|
      from = from.to_datetime
      to = [from + 1.year, DateTime.now.beginning_of_hour].min
      if from > 4.hours.ago
        @@logger.info "has data in last 4 hours. skipping"
        next
      end

      yield ENTSOE::Load.new(country: country, from: from, to: to)
    end
  end
end
