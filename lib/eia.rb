require 'httparty'
module Eia
  class Base
    def self.source_id
      "eia"
    end
    FUEL_MAP = {
      'COL' => 'fossil_hard_coal',
      'NG' => 'fossil_gas',
      'NUC' => 'nuclear',
      'OIL' => 'fossil_oil',
      'OTH' => 'other',
      'SUN' => 'solar',
      'WAT' => 'hydro',
      'WND' => 'wind'
    }
    def httparty_retry(&block)
      retries = 0
      loop do
        r = yield
        return r if r.ok?

        retries += 1
        raise if retries >= 5
        logger.warn "Retrying in 5: #{r.inspect}"
        sleep 5
      end
    end
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    URL = "https://api.eia.gov/v2/electricity/rto/region-data/data/"
    QUERY_PARAMS = {}
    def initialize(country: nil, from: nil, to: nil)
      @from = from
      @to = to + 1.hour
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime("%Y-%m-%d"),
        end: to.strftime("%Y-%m-%d"),
        offset: 0,
        'data[]': 'value',
        'facets[type][]': 'D'
      }
      query['facets[respondent][]'] = country if country
      logger.info("from: #{query[:start]} to: #{query[:end]}")
      @res = []
      loop do
        res = logger.benchmark_info(URL) do
          httparty_retry do
            HTTParty.get(
              URL,
              query: query,
              #debug_output: $stdout
            )
          end
        end
        logger.info "eia.gov query execution: #{res.parsed_response['response']['query execution']}"
        logger.info "eia.gov count query execution: #{res.parsed_response['response']['count query execution']}"
        @res << res

        if query[:offset] + res.parsed_response['response']['data'].length >= res.parsed_response['response']['total']
          break
        end
        query[:offset] += res.parsed_response['response']['data'].length
      end
    end
    def points
      r = []
      @res.each do |res|
        res.parsed_response['response']['data'].each do |row|
          if row['value'].nil?
            logger.warn "Null value #{row.inspect}"
            next
          end
          if row['value'] < 0
            logger.warn("Negative load #{row.inspect}")
            next
          end
          if row['respondent'] == 'BANC' && row['value'] > 6000
            logger.warn("Ignoring load #{row['value']} from #{row['respondent']}")
            next
          end
          time = Time.strptime(row['period'], '%Y-%m-%dT%H')
          r << {
            time: time,
            country: row['respondent'],
            value: row['value']
          }
        end
      end
      #require 'pry' ; binding.pry

      r.select { |p| p[:value] < 800_000 }
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = "https://api.eia.gov/v2/electricity/rto/fuel-type-data/data/"
    def initialize(country: nil, from: nil, to: nil)
      @from = from
      @to = to + 1.hour
      query = {
        api_key: ENV['EIA_TOKEN'],
        frequency: 'hourly',
        start: from.strftime("%Y-%m-%d"),
        end: to.strftime("%Y-%m-%d"),
        'data[]': 'value',
        #'facets[fueltype][]': '{}',
      }
      logger.info("from: #{query[:start]} to: #{query[:end]}")
      query['facets[respondent][]'] = country if country
      query[:offset] = 0
      @res = []
      loop do
        res = httparty_retry do
          HTTParty.get(
            URL,
            query: query,
            #debug_output: $stdout
          )
        end
        @res << res
        if query[:offset] + res.parsed_response['response']['data'].length >= res.parsed_response['response']['total']
          break
        end
        query[:offset] += res.parsed_response['response']['data'].length
      end
    end

    def points
      r = []
      @res.each do |res|
        res.parsed_response['response']['data'].each do |row|
          raise row['fueltype'] if FUEL_MAP[row['fueltype']].nil?
          if row['value'].nil?
            logger.warn "Null value #{row.inspect}"
            next
          end
          time = Time.strptime(row['period'], '%Y-%m-%dT%H')
          r << {
            time: time,
            country: row['respondent'],
            production_type: FUEL_MAP[row['fueltype']],
            value: row['value']
          }
        end
      end
      #require 'pry' ; binding.pry

      r.select { |p| !(p[:production_type] == 'wind' && p[:value] > 10_000) }
    end
  end
end
