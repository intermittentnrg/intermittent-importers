require 'chronic'
require 'csv'
require 'faraday'

module Eirgrid
  class Base
    TZ = TZInfo::Timezone.get('Europe/Dublin')
    COUNTRY = 'IE'
    CSV_URL = 'https://www.smartgriddashboard.com/DashboardService.svc/csv'

    def initialize
      @r = []
      @from = nil
      @to = nil
    end

    def self.source_id
      'eirgrid'
    end

    def self.cli(args)
      raise 'Arguments required' if args.length < 2

      from = Chronic.parse(args[0]).to_date
      to = Chronic.parse(args[1]).to_date
      new.add_date_range(from, to).done!
    end

    def update_time_range(time)
      @from = [@from, time].compact.min
      @to = [@to, time].compact.max
    end
  end

  class WindGeneration < Base
    include SemanticLogger::Loggable

    AREA = 'windactual'
    COLUMN_INDEX = 2  # 3rd column: "ACTUAL WIND(MW)"

    def add_date_range(from, to)
      @from = from.to_time.utc
      @to = to.to_time.utc

      (from..to).each do |date|
        fetch_wind_data(date)
      end
      self
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
    end

    private

    def fetch_wind_data(date)
      params = {
        area: AREA,
        region: 'ALL',
        datefrom: "#{date.strftime('%d-%b-%Y')} 00:00",
        dateto: "#{date.strftime('%d-%b-%Y')} 23:59"
      }

      response = logger.benchmark_info("EirGrid Wind #{date}") do
        Faraday.get(CSV_URL, params)
      end

      parse_wind_csv(response.body)
    end

    def parse_wind_csv(csv_data)
      CSV.parse(csv_data, headers: true) do |row|
        next if row['DATE & TIME'].nil?

        time = Time.strptime(row['DATE & TIME'], '%d %B %Y %H:%M')
        time = TZ.local_to_utc(time)

        wind_value = row[COLUMN_INDEX]
        next if wind_value.nil?

        update_time_range(time)
        @r << {
          time: time,
          country: COUNTRY,
          production_type: 'wind_onshore',
          value: wind_value.to_f
        }
      end
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    AREA = 'demandActual'
    COLUMN_INDEX = 1  # 2nd column: "ACTUAL DEMAND(MW)"

    def add_date_range(from, to)
      @from = from.to_time.utc
      @to = to.to_time.utc

      (from..to).each do |date|
        fetch_load_data(date)
      end
      self
    end

    def done!
      Out::Load.run(@r, @from, @to, self.class.source_id)
    end

    private

    def fetch_load_data(date)
      params = {
        area: AREA,
        region: 'ALL',
        datefrom: "#{date.strftime('%d-%b-%Y')} 00:00",
        dateto: "#{date.strftime('%d-%b-%Y')} 23:59"
      }

      response = logger.benchmark_info("EirGrid Load #{date}") do
        Faraday.get(CSV_URL, params)
      end

      parse_load_csv(response.body)
    end

    def parse_load_csv(csv_data)
      CSV.parse(csv_data, headers: true) do |row|
        next if row['DATE & TIME'].nil?

        time = Time.strptime(row['DATE & TIME'], '%d %B %Y %H:%M')
        time = TZ.local_to_utc(time)

        demand_value = row[COLUMN_INDEX]
        next if demand_value.nil?

        update_time_range(time)
        @r << {
          time: time,
          country: COUNTRY,
          value: demand_value.to_f
        }
      end
    end
  end

  class Price < Base
    include SemanticLogger::Loggable

    PRICE_URL = 'https://reports.sem-o.com/api/v1/dynamic/BM-026'

    def add_date_range(from, to)
      @from = from.to_time.utc
      @to = to.to_time.utc

      params = {
        StartTime: ">=#{from.strftime('%Y-%m-%dT00:00')}",
        EndTime: "<#{to.strftime('%Y-%m-%dT00:00')}",
        page_size: 500
      }

      response = logger.benchmark_info("EirGrid Price #{from} #{to}") do
        Faraday.get(PRICE_URL, params)
      end

      parse_price_data(JSON.parse(response.body))
      self
    end

    def done!
      Out::Price.run(@r, @from, @to, self.class.source_id)
    end

    private

    def parse_price_data(json_data)
      json_data['items'].each do |item|
        next if item['ImbalanceSettlementPrice'].nil?

        time = Time.parse(item['StartTime'])
        price = item['ImbalanceSettlementPrice'].to_f

        update_time_range(time)
        @r << {
          time: time,
          country: COUNTRY,
          value: price
        }
      end
    end
  end
end
