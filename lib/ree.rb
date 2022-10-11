require 'httparty'

class Ree
  class Generation
    def self.source_id
      "ree"
    end
    def initialize(date)
      @options = {}
      @options[:curva] = "LZ_FV5M"
      @options[:fecha] = date.strftime('%Y-%m-%d')
      @system = "Canarias"
      @res = HTTParty.get(
        "https://demanda.ree.es/WSvisionaMoviles#{@system}Rest/resources/demandaGeneracion#{@system}",
        query: @options,
        debug_output: $stdout
      )
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
      JSON.parse(@res.body.gsub(/^\w+\(|[^}]+$/,'\1'))["valoresHorariosGeneracion"].each do |row|
        time = DateTime.strptime(row.delete("ts"), '%Y-%m-%d %H:%M')
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
