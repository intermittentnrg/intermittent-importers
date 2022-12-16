require 'semantic_logger'
require 'composite_primary_keys'
require './lib/elexon'

class Load < ActiveRecord::Base
  @@logger = SemanticLogger[Load]
  self.table_name = 'load'
  belongs_to :area

  def self.parsers_each(source)
    self.joins(:area).group(:'area.code').where("time > ?", 12.months.ago).where(area: {source: source.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
      from = from.to_datetime
      to = [from + 1.year, DateTime.now.beginning_of_hour].min
      SemanticLogger.tagged(country) do
        # support source per day and date-range
        #require 'pry' ; binding.pry
        if source == Elexon::Load
          (from..to).each do |date|
            yield source.new date
          end
        elsif source == Ieso::Load
          (from.year..to.year).each do |year|
            yield source.new(DateTime.strptime(year.to_s, '%Y'))
          end
        else
          yield source.new(country: country, from: from, to: to)
        end
      end
    end
  end
end
