class SvkMimerGeneration < ActiveRecord::Base
  self.table_name = 'svk_mimer_generation'

  def self.parsers_each
    self.group(:country, :production_type).where("time > ?", 1.month.ago).pluck(:country, :production_type, Arel.sql("LAST(time, time)")).each do |country, production_type, from|
      #require 'pry' ; binding.pry
      from = from.to_datetime
      to = [from + 1.year, DateTime.now.beginning_of_hour].min

      yield Svk::Generation.new(country: country, production_type: production_type, from: from, to: to)
    end
  end
end
