# frozen_string_literal: true

require 'faraday/follow_redirects'
require 'fast_jsonparser'

module Ercot
  class Base
    TZ = TZInfo::Timezone.get('America/Chicago')
    def self.source_id
      'ercot'
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    def self.cli(args)
      raise 'At most one argument allowed' if args.size > 1

      if args[0]
        new.add_file(args[0]).done!
      else
        new.add.done!
      end
    end

    FUEL_MAP = {
      'Coal and Lignite': 'fossil_coal',
      'Hydro': 'hydro',
      'Nuclear': 'nuclear',
      'Other': 'other',
      'Power Storage': 'storage',
      'Solar': 'solar',
      'Wind': 'wind',
      'Natural Gas': 'fossil_gas'
    }.freeze
    # URL = 'https://www.ercot.com/api/1/services/read/dashboards/fuel-mix.json'
    URL = 'https://nfqqioz1r2.execute-api.us-east-2.amazonaws.com/dev/KNputxby5cAFWSDYDbjgWbLDcPr78B68'

    def initialize
      @r = []
      @from = nil
      @to = nil
    end

    def add
      faraday = Faraday.new do |f|
        f.response :follow_redirects
      end
      res = faraday.get(URL) do |request|
        request.headers['x-api-key'] = ENV['ERCOT_PROXY_API_KEY']
      end
      add_json(FastJsonparser.parse(res.body))
    end

    def add_file(path)
      add_json(FastJsonparser.load(path))
    end

    def add_json(json)
      json[:data].each_value do |date_group|
        date_group.each do |time, production_type_group|
          time = Time.strptime(time.to_s, '%Y-%m-%d %H:%M:%S')
          time = TZ.local_to_utc(time)
          production_type_group.each do |production_type_name, data|
            value = data[:gen] * 1000
            production_type = FUEL_MAP[production_type_name]
            @r << { country: 'ERCOT', production_type:, time:, value: }
          end
        end
      end
      @from = @r.first[:time]
      @to = @r.last[:time]
      self
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
    end
  end
end
