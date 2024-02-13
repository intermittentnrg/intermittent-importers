module Out
  module Generation
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def parsers_each
        ::Generation.joins(:areas_production_type => :area).group(:'area.code').where("time > ?", 2.months.ago).where(area: {source: self.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
          from2 = from
          from = from.in_time_zone(self::TZ).to_datetime
          to = [from + 1.year, DateTime.tomorrow.beginning_of_day].min
          to = to.in_time_zone(self::TZ).to_datetime
          SemanticLogger.tagged(country) do
            # support source per day and date-range
            #require 'pry' ; binding.pry
            if [::Elexon::Generation, ::Elexon::Fuelinst, ::Ree::Generation].include? self
              logger.info("Refresh from #{from} calculated from last point #{from2}")
              (from..to).each do |date|
                yield self.new date
              rescue EmptyError
                logger.warn "Empty response #{date}"
              end
            else
              yield self.new(country: country, from: from, to: to)
            end
          end
        end
      end
    end

    def process
      process_generation
    end
    def process_generation
      data = points_generation
      len = ::Out2::Generation.run(data, @from, @to, self.class.source_id)
      logger.info("updated #{len} out of #{data.length} rows")
      done!
    end
    def done!
      super
    rescue NoMethodError
    end
  end

  module Unit
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def self.refresh_to
        DateTime.now
      end
      def parsers_each
        from =::GenerationUnit.joins(:unit => :area).where("area.source" => self.source_id).where("time > ?", 2.months.ago).maximum(:time)
        from = from.to_datetime
        if [::Elexon::Unit].include? self
          (from..refresh_to).each do |date|
            yield self.new(date)
          rescue EmptyError
            logger.warn "Empty response #{date}"
          end
        else
          raise
        end
      end
    end
    def process
      ::Out2::Unit.run(points, @from, @to, self.class.source_id)
      done!
    end
    def done!
      super
    rescue NoMethodError
    end
  end

  module Load
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def parsers_each
        ::Load.joins(:area).group(:'area.code').where("time > ?", 12.months.ago).where(area: {source: self.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
          from = from.in_time_zone(self::TZ).to_datetime
          to = [from + 1.year, DateTime.tomorrow.beginning_of_day].min
          to = to.in_time_zone(self::TZ).to_datetime
          SemanticLogger.tagged(country) do
            # support source per day and date-range
            #require 'pry' ; binding.pry
            if [::Elexon::Load].include? self
              (from..to).each do |date|
                yield self.new date
              rescue EmptyError
                logger.warn "Empty response #{date}"
              end
            elsif self == ::Ieso::Load
              (from.year..to.year).each do |year|
                yield self.new(DateTime.strptime(year.to_s, '%Y'))
              rescue EmptyError
                logger.warn "Empty response #{year}"
              end
            else
              yield self.new(country: country, from: from, to: to)
            end
          end
        end
      end
    end

    def process
      process_load
    end
    def process_load
      ::Out2::Load.run(points_load, @from, @to, self.class.source_id)
      done!
    end
    def done!
      super
    rescue NoMethodError
    end
  end

  module Price
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def parsers_each
        ::Price.joins(:area).group(:'area.code').where("time > ?", 6.month.ago).where(area: {source: self.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
          SemanticLogger.tagged(country) do
            from = from.to_datetime
            to = [from + 1.year, DateTime.tomorrow.to_datetime.beginning_of_hour].min
            if from.to_date == to
              logger.warn "data is up to date"
              next
            end

            if self == ::Nordpool::PriceSEK
              (from..to).each do |date|
                yield self.new date
              rescue EmptyError
                logger.warn "Empty response #{date}"
              end
            else
              yield self.new(country: country, from: from, to: to)
            end
          end
        end
      end
    end

    def process
      process_price
    end
    def process_price
      ::Out2::Price.run(points_price, @from, @to, self.class.source_id)
      done!
    end
    def done!
      super
    rescue NoMethodError
    end
  end

  module Transmission
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def parsers_each
        ::Transmission.joins(:from_area) \
            .joins('INNER JOIN "areas" "to_area" ON "to_area"."id" = "transmission"."to_area_id"') \
            .group(:'from_area.code', :'to_area.code') \
            .where("time > ?", 12.months.ago) \
            .where(from_area: {source: self.source_id}) \
            .pluck(:'from_area.code', :'to_area.code', Arel.sql("LAST(time, time)")) \
            .each do |from_area, to_area, from|
          #require 'pry' ; binding.pry
          from = from.to_datetime
          to = [from + 1.year, DateTime.now.beginning_of_hour].min
          SemanticLogger.tagged("#{from_area} > #{to_area}") do
            # support source per day and date-range
            #require 'pry' ; binding.pry
            if self == Nordpool::Transmission
              (from..to).each do |date|
                yield self.new date
              rescue EmptyError
                logger.warn "Empty response #{date}"
              end
            else
              yield self.new(from_area: from_area, to_area: to_area, from: from, to: to)
            end
          end
        end
      end
    end

    def process
      ::Out2::Transmission.run(points, @from, @to, self.class.source_id)
      done!
    end
    def done!
      super
    rescue NoMethodError
    end
  end

  module Capacity
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      #The available trading capacities for the next day are published on Nord Pools website at 10:00 CET
      def parsers_each(&block)
        from = ::Transmission.joins(:from_area) \
                 .group(:'from_area.code') \
                 .where('capacity IS NOT NULL') \
                 .where(from_area: {source: self.source_id}) \
                 .where("time > '2022-10-05'") \
                 .pluck(Arel.sql("LAST(time, time)")).min.try(:to_datetime).try(:next_day)
        #require 'pry' ; binding.pry
        from ||= Date.parse("2021-10-01")
        to = 2.days.from_now
        (from..to).each do |date|
          #require 'pry' ; binding.pry
          yield self.new(date)
        rescue EmptyError
          logger.warn "Empty response #{date}"
        end
      end
    end

    def process
      raise unless @from && @to
      areas = {}
      data = points
      #require 'pry' ;binding.pry
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      data.each do |p|
        p[:from_area_id] = (areas[p[:from_area]] ||= ::Area.where(source: self.class.source_id, code: p[:from_area]).pluck(:id).first)
        p[:to_area_id] = (areas[p[:to_area]] ||= ::Area.where(source: self.class.source_id, code: p[:to_area]).pluck(:id).first)
        p.delete :from_area
        p.delete :to_area
      end

      ::Transmission.upsert_all(data) if data.present?
    end
  end
end
