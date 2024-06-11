require 'faraday'
require 'fastest_csv'

module Eskom
  class Base
    TZ = TZInfo::Timezone.get('Africa/Johannesburg')
    def self.source_id
      "eskom"
    end

    def self.cli(args)
      case args.length
      when 0
        new.process
      when 1
        new(args[0]).process
      else
        $stderr.puts "#{$0} [file]"
        exit
      end
    end

    def initialize(from_or_path = Date.today)
      @from = from_or_path
    end

    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
    def fetch
      if @from.is_a? Date
        @url = @from.strftime(self.class::URL_FORMAT)
        @filedate = DataFile.where(path: File.basename(@url), source: self.class.source_id).pluck(:updated_at).first
        res = logger.benchmark_info(@url) do
          Faraday.get(@url) do |req|
            if @filedate
              req.headers['If-Modified-Since'] = @filedate.strftime(HTTP_DATE_FORMAT)
            end
          end
        end
        if res.status == 304 #Not Modified
          raise EmptyError
        end
        @filedate = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)
        @csv = FastestCSV.parse(res.body, row_sep: "\r\n")
      else
        @csv = FastestCSV.read(@from, row_sep: "\r\n")
      end
    end

    def done!
      DataFile.upsert({path: File.basename(@url), source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{@url}"
    end
    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'
    def parse_time(s)
      time = Time.strptime(s, self.class::TIME_FORMAT)
      time = TZ.local_to_utc(time)
    end
  end

  class Demand < Base
    include SemanticLogger::Loggable
    include Out::Load

    URL_FORMAT = 'https://www.eskom.co.za/dataportal/wp-content/uploads/%Y/%m/System_hourly_actual_and_forecasted_demand.csv'

    def points_load
      fetch
      r = []
      logger.benchmark_info('csv parse') do
        @csv.shift
        @csv.each do |row|
          #0 DateTimeKey
          time = parse_time(row[0])
          #1 Residual Forecast
          #2 RSA Contracted Forecast
          #3 Residual Demand
          #4 RSA Contracted Demand
          next unless row[4].present?
          value = row[4].to_f*1000
          r << {country: 'ZA', time:, value:}
        end
      end
      @from = r.first[:time]
      @to = r.last[:time]
      #require 'pry' ; binding.pry

      r
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL_FORMAT = "https://www.eskom.co.za/dataportal/wp-content/uploads/%Y/%m/Station_Build_Up.csv"

    def points_generation
      fetch
      r = []
      logger.benchmark_info('csv parse') do
        @csv.shift
        @csv.each do |row|
          #0 Date_Time_Hour_Beginning
          time = parse_time(row[0])
          #1 Thermal_Gen_Excl_Pumping_and_SCO
          r << {country: 'ZA', time:, production_type: 'fossil_coal', value: row[1].to_f*1000}
          #2 Eskom_OCGT_SCO_Pumping
          #3 Eskom_Gas_SCO_Pumping
          #4 Hydro_Water_SCO_Pumping
          #5 Pumped_Water_SCO_Pumping
          #6 Thermal_Generation - sum of above. Can be ignored
          #7 Nuclear_Generation
          r << {country: 'ZA', time:, production_type: 'nuclear', value: row[7].to_f*1000}
          #8 International_Imports
          #FIXME r_tran
          #9 Eskom_OCGT_Generation
          #added to OCGT below
          #10 Eskom_Gas_Generation
          r << {country: 'ZA', time:, production_type: 'fossil_gas', value: row[10].to_f*1000}
          #11 Dispatchable_IPP_OCGT
          r << {country: 'ZA', time:, production_type: 'fossil_oil', value: (row[9].to_f+row[11].to_f)*1000}
          #12 Hydro_Water_Generation
          r << {country: 'ZA', time:, production_type: 'hydro', value: row[12].to_f*1000}
          #13 Pumped_Water_Generation
          r << {country: 'ZA', time:, production_type: 'hydro_pumped_storage', value: (row[5].to_f+row[13].to_f)*1000}
          #14 IOS_Excl_ILS_and_MLR - Interruption of Supply
          #15 ILS_Usage - Interruptible Load Shed
          #16 Manual_Load_Reduction_MLR - MLS = forced load shedding
          #17 Wind
          r << {country: 'ZA', time:, production_type: 'wind', value: row[17].to_f*1000}
          #18 PV
          r << {country: 'ZA', time:, production_type: 'solar', value: row[18].to_f*1000}
          #19 CSP
          r << {country: 'ZA', time:, production_type: 'solar_thermal', value: row[19].to_f*1000}
          #20 Other_RE
          r << {country: 'ZA', time:, production_type: 'other_renewable', value: row[20].to_f*1000}
        end
      end
      @from = r.first[:time]
      @to = r.last[:time]
      #require 'pry' ; binding.pry

      r
    end
  end

  class Historical < Base
    TIME_FORMAT = '%Y-%m-%d %I:%M:%S %p'
    def process
      fetch
      header = @csv.shift
      map = header.each_with_index.to_h
      r_gen = []
      r_tran = []
      r_load = []
      @csv.each do |row|
        next if row[1..].all? {|v|v.blank?}
        time = parse_time(row[0])

        value = row[map['RSA Contracted Demand']].to_f*1000
        r_load << {country: 'ZA', time:, value:}

        #value = row[map['International Imports']].to_f*1000 - row[map['International Exports']].to_f*1000
        #r_tran << {from_country: 'ZA', to_country: 'other', time:, value:}

        # missing: Thermal_Gen_Excl_Pumping_and_SCO
        value = row[map['Thermal Generation']].to_f*1000 -
                row[map['Eskom OCGT SCO']].to_f*1000 -
                row[map['Eskom Gas SCO']].to_f*1000 -
                row[map['Hydro Water SCO']].to_f*1000 -
                row[map['Pumped Water SCO Pumping']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'fossil_coal', value:}

        value = row[map['Nuclear Generation']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'nuclear', value:}

        value = row[map['Eskom Gas Generation']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'fossil_gas', value:}

        value = row[map['Eskom OCGT Generation']].to_f*1000 + row[map['Dispatchable IPP OCGT']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'fossil_oil', value:}

        value = row[map['Hydro Water Generation']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'hydro', value:}

        value = row[map['Pumped Water Generation']].to_f*1000 + row[map['Pumped Water SCO Pumping']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'hydro_pumped_storage', value:}

        value = row[map['Wind']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'wind', value:}

        value = row[map['PV']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'solar', value:}

        value = row[map['CSP']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'solar_thermal', value:}

        value = row[map['Other RE']].to_f*1000
        r_gen << {country: 'ZA', time:, production_type: 'other_renewable', value:}
      end

      @from = r_load.first[:time]
      @to = r_load.last[:time]

      Out2::Generation.run(r_gen, @from, @to, self.class.source_id)
      Out2::Load.run(r_load, @from, @to, self.class.source_id)
      #Out2::Transmission.run(r_tran, @from, @to, self.class.source_id)
    end
  end
end
