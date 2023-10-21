require 'faraday/follow_redirects'

module Ercot
  class Base
    TZ = TZInfo::Timezone.get('America/Chicago')
    def self.source_id
      "ercot"
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def self.cli(args)
      if args[0]
        new(args[0]).process
      else
        new.process
      end
    end

    FUEL_MAP = {
      :'Coal and Lignite' => 'fossil_coal',
      :'Hydro' => 'hydro',
      :'Nuclear' => 'nuclear',
      :'Other' => 'other',
      :'Power Storage' => 'storage',
      :'Solar' => 'solar',
      :'Wind' => 'wind',
      :'Natural Gas' => 'fossil_gas'
    }
    #URL = 'https://www.ercot.com/api/1/services/read/dashboards/fuel-mix.json'
    URL = 'https://nfqqioz1r2.execute-api.us-east-2.amazonaws.com/dev/KNputxby5cAFWSDYDbjgWbLDcPr78B68'
    def initialize(path = nil)
      @path = path
    end

    def points_generation
      if @path
        json = FastJsonparser.load(@path)
      else
        faraday = Faraday.new do |f|
          f.response :follow_redirects
        end
        res = faraday.get(URL) do |request|
          request.headers['x-api-key'] = ENV['ERCOT_PROXY_API_KEY']
        end
        json = FastJsonparser.parse(res.body)
      end
      #require 'pry' ; binding.pry
      production_types = {}
      r = []
      json[:data].each do |_, date_group|
        date_group.each do |time, production_type_group|
          time = Time.strptime(time.to_s, '%Y-%m-%d %H:%M:%S')
          time = TZ.local_to_utc(time)
          production_type_group.each do |production_type_name, data|
            value = data[:gen]*1000
            production_type = FUEL_MAP[production_type_name]
            r << {country: 'ERCOT', production_type:, time:, value:}
          end
        end
      end
      #require 'pry' ; binding.pry
      @from = r.first[:time]
      @to = r.last[:time]

      r
    end
  end
end
