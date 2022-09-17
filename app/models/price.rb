require 'semantic_logger'
require 'composite_primary_keys'

class Price < ActiveRecord::Base
  @@logger = SemanticLogger[Price]
  belongs_to :area

  def self.parsers_each(source)
    self.joins(:area).group(:'area.code').where("time > ?", 6.month.ago).where(area: {source: source.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
      from = from.to_datetime
      to = [from + 1.year, DateTime.tomorrow.to_datetime.beginning_of_hour].min

      yield ENTSOE::Price.new(country: country, from: from, to: to)
    end
  end
end
