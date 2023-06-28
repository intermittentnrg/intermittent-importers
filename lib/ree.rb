require 'httparty'

class Ree
  class Generation
    include SemanticLogger::Loggable
    include Out::Generation

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
      "die" => "fossil_oil",
      "gas" => "fossil_gas",
      "eol" => "wind_onshore",
      "cc" => "fossil_gas",
      "vap" => "fossil_oil",
      "fot" => "solar",
      "hid" => "hydro_pumped_storage"
    }
    def points
      r = []
      json = JSON.parse(@res.body.gsub(/^\w+\(|[^}]+$/,'\1'))
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

        row.delete "dem"
        row.delete "vap"
        row.delete "cc"
        row.each do |k,v|
          r << {
            time: time,
            country: 'ES-CN-FVLZ',
            production_type: PRODUCTION_TYPES[k],
            value: v
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
