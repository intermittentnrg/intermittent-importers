class ElexonGeneration < ActiveRecord::Base
  self.table_name = 'elexon_generation'

  def self.parsers_each
    self.where("time > ?", 2.month.ago).pluck(Arel.sql("LAST(time, time)")).each do |from|
      from = from.to_datetime
      to = [from + 1.year, DateTime.now.beginning_of_hour].min
      if from > 4.hours.ago
        @@logger.info "has data in last 4 hours. skipping"
        next
      end

      (from..to).each do |date|
        yield Elexon::Generation.new date
      end
    end
  end
end
