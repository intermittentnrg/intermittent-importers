require 'httparty'
require 'chronic'

class Ree
  class Generation
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = self.new(time)
        e.process
      end
    end

    def self.parsers_each
      ::Generation.joins(:areas_production_type => :area).group(:'area.code').where("time > ?", 2.months.ago).where(area: {source: self.source_id}).pluck(:'area.code', Arel.sql("LAST(time, time)")).each do |country, from|
        from2 = from
        from = from.in_time_zone(self::TZ).to_datetime
        to = [from + 1.year, DateTime.tomorrow.beginning_of_day].min
        to = to.in_time_zone(self::TZ).to_datetime
        SemanticLogger.tagged(country) do
          (from..to).each do |date|
            yield self.new date
          rescue EmptyError
            logger.warn "Empty response #{date}"
          end
        end
      end
    end

    TZ = TZInfo::Timezone.get('Atlantic/Canary')
    def self.source_id
      "ree"
    end
    def initialize(date)
      @from = date - 6.hours
      @to = date + 1.day
      @options = {}
      @options[:curva] = "LZ_FV5M"
      @options[:fecha] = date.strftime('%Y-%m-%d')
      @system = "Canarias"
      url = "https://demanda.ree.es/WSvisionaMoviles#{@system}Rest/resources/demandaGeneracion#{@system}"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: @options,
          #debug_output: $stdout
        )
      end
      #require 'pry' ; binding.pry
    end
    PRODUCTION_TYPES = {
      'die' => 'fossil_oil',
      'gas' => 'fossil_gas',
      'eol' => 'wind_onshore',
      'cc' => false, #'fossil_gas',
      'vap' => false, #'fossil_oil',
      'fot' => 'solar',
      'hid' => 'hydro_pumped_storage',
      'gnhd' => false, # Hydro
      'turb' => false, # Pumping Turbine
      'conb' => false, # Pumping consumption
      'efl' => false, # exchange ??
      'dem' => false, #FIXME demand
    }
    def process
      r = []
      json = JSON.parse(@res.body.gsub(/^\w+\(|[^}]+$/,'\1'))
      raise @res.body unless json["valoresHorariosGeneracion"]
      json["valoresHorariosGeneracion"].each do |row|
        leap = 0
        time = row.delete("ts")
        if time.include?('1A')
          leap = 0
          time.gsub!(/1A/,'01')
        elsif time.include?('1B')
          leap = 1
          time.gsub!(/1B/,'01')
        end
        time = Time.strptime(time, '%Y-%m-%d %H:%M')
        time = TZ.local_to_utc(time) { |periods| periods[leap] }

        row.each do |k,value|
          raise k if PRODUCTION_TYPES[k].nil?
          next if PRODUCTION_TYPES[k] == false
          r << {
            time: time,
            country: 'ES-CN-FVLZ',
            production_type: PRODUCTION_TYPES[k],
            value: (value*1000).to_i
          }
        end
      end
      #require 'pry' ; binding.pry

      Out2::Generation.run(r, @from, @to, self.class.source_id)
    end
  end
end
