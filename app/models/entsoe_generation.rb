class EntsoeGeneration < ActiveRecord::Base
  self.table_name = 'entsoe_generation'

  def self.parsers_each
    self.group(:country).where("time > ?", 1.month.ago).pluck(:country, Arel.sql("LAST(time, time)")).each do |country, from|
      from = from.to_datetime
      to = [from + 1.year, DateTime.now.beginning_of_hour].min
      if from > 4.hours.ago
        @@logger.info "has data in last 4 hours. skipping"
        next
      end

      yield ENTSOE::Generation.new(country: country, from: from, to: to)
    end
  end
end
