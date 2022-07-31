require 'semantic_logger'
require 'composite_primary_keys'

class Transmission < ActiveRecord::Base
  @@logger = SemanticLogger[Transmission]
  self.table_name = 'transmission'
  belongs_to :from_area, class_name: 'Area'
  belongs_to :to_area, class_name: 'Area'


  def self.parsers_each(source)
    self.joins(:from_area) \
        .joins('INNER JOIN "areas" "to_area" ON "to_area"."id" = "transmission"."to_area_id"') \
        .group(:'from_area.code', :'to_area.code').where("time > ?", 12.months.ago).where(from_area: {source: source.source_id}).pluck(:'from_area.code', :'to_area.code', Arel.sql("LAST(time, time)")).each do |from_country, to_country, from|
      #require 'pry' ; binding.pry
      from = from.to_datetime
      to = [from + 1.year, DateTime.now.beginning_of_hour].min
      if from > 4.hours.ago
        @@logger.info "has data in last 4 hours. skipping"
        next
      end
      SemanticLogger.tagged("#{from_country} > #{to_country}") do
        # support source per day and date-range
        #require 'pry' ; binding.pry
        yield source.new(from_area: from_country, to_area: to_country, from: from, to: to)
      end
    end
  end
end
