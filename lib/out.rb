module Out
  module Generation
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def refetch
        0
      end
      def parsers_each
        ::Generation.joins(:area).group(:'area.code').where("time > ?", 2.months.ago).where(area: {source: self.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
          from = from.to_datetime - refetch
          to = [from + 1.year, DateTime.tomorrow.beginning_of_day].min
          SemanticLogger.tagged(country) do
            # support source per day and date-range
            #require 'pry' ; binding.pry
            if [::Caiso::Generation, ::Elexon::Generation, ::Elexon::Fuelinst, ::Ieso::Generation, ::Ree::Generation].include? self
              (from..to).each do |date|
                yield self.new date
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
      ::Out2::Generation.run(points_generation, @from, @to, self.class.source_id)
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
      def refetch
        0
      end
      def parsers_each
        ::GenerationUnit.group(:unit_id).joins(:unit => :area).where("area.source" => self.source_id).where("time > ?", 2.months.ago).pluck(:unit_id, Arel.sql("LAST(time, time)")).each do |unit_id, from|
          unit = ::Unit.find(unit_id)
          from = from.to_datetime - refetch
          to = DateTime.now
          SemanticLogger.tagged(unit.internal_id) do
            if [::Elexon::Unit].include? self
              (from..to).each do |date|
                yield self.new(date, unit.internal_id)
              rescue ENTSOE::EmptyError
                logger.error "Exception processing #{date}", $!
              end
            end
          end
          #require 'pry' ; binding.pry
        end
      end
    end
    def process
      data = points

      #FIXME diff calculation
      #raise unless @from && @to

      unless data.present?
        require 'pry' ; binding.pry
      end
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      if data.present?
        logger.benchmark_info("upsert") do
          data.each_slice(1_000_000) do |data2|
            ::GenerationUnit.upsert_all(data2)
          end
        end
        done!
      end
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
      def refetch
        0
      end
      def parsers_each
        ::Load.joins(:area).group(:'area.code').where("time > ?", 12.months.ago).where(area: {source: self.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
          from = from.to_datetime - refetch
          to = [from + 1.year, DateTime.tomorrow.beginning_of_day].min
          SemanticLogger.tagged(country) do
            # support source per day and date-range
            #require 'pry' ; binding.pry
            if self == ::Elexon::Load
              (from..to).each do |date|
                yield self.new date
              end
            elsif self == ::Ieso::Load
              (from.year..to.year).each do |year|
                yield self.new(DateTime.strptime(year.to_s, '%Y'))
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
      #raise unless @from && @to
      areas = {}
      area_ids = Set.new
      data = points_price
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"

      data.each do |p|
        p[:area_id] = (areas[p[:country]] ||= ::Area.where(source: self.class.source_id, code: p[:country]).pluck(:id).first) if p[:country]
        unless p[:area_id]
          require 'pry' ; binding.pry
        end
        area_ids << p[:area_id]
        p.delete :country
      end

      if @from && @to && area_ids.present?
        logger.benchmark_info("diff calculation") do
          rows=::Price.where(time: @from...@to).where(area_id: area_ids).order(:time)
          rows=rows.map { |r| r.attributes.symbolize_keys }
          index = Hash[rows.map { |r| [[r[:area_id], r[:time]], r] }]
          data.each do |p|
            k = [p[:area_id], p[:time]]
            old = index[k]
            if old && old[:value] != p[:value]
              logger.warn "updated #{old[:value]} > #{p[:value]}", event: {duration: Time.now-p[:time]}, price: p
            #elsif old
            #  logger.info "good"
            end
          end

        end
      end
      #require 'pry' ; binding.pry

      if data.present?
        logger.benchmark_info("upsert") do
          ::Price.upsert_all(data) if data.present?
        end
        done!
      end
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
              end
            else
              yield self.new(from_area: from_area, to_area: to_area, from: from, to: to)
            end
          end
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

      logger.benchmark_info("diff calculation") do
        rows=::Transmission.where(time: @from...@to).where(from_area_id: areas[@from_area], to_area_id: areas[@to_area]).order(:time)
        rows=rows.map { |r| r.attributes.symbolize_keys }

        diff = data-rows
        if diff
          diff.each do |d|
            logger.warn "new or updated", event: {duration: Time.now-d[:time]}, transmission: d
          end
        end

        #require 'pry' ; binding.pry
      end

       ::Transmission.upsert_all(data) if data.present?
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
                 .where(:'from_area.enabled' => true) \
                 .where(from_area: {source: self.source_id}) \
                 .where("time > '2022-10-05'") \
                 .pluck(Arel.sql("LAST(time, time)")).min.try(:to_datetime).try(:next_day)
        #require 'pry' ; binding.pry
        from ||= Date.parse("2021-10-01")
        to = 2.days.from_now
        (from..to).each do |date|
          #require 'pry' ; binding.pry
          yield self.new(date)
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

      logger.benchmark_info("diff calculation") do
        rows=::Transmission.where(time: @from...@to).where(from_area_id: areas[@from_area], to_area_id: areas[@to_area]).order(:time)
        rows=rows.map { |r| r.attributes.symbolize_keys }

        diff = data-rows
        if diff
          diff.each do |d|
            logger.warn "new or updated", event: {duration: Time.now-d[:time]}, capacity: d
          end
        end

        #require 'pry' ; binding.pry
      end

      ::Transmission.upsert_all(data) if data.present?
    end
  end
end
