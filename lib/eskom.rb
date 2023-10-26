module Eskom
  class Base
    TZ = TZInfo::Timezone.get('Africa/Johannesburg')
    def self.source_id
      "eskom"
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL_FORMAT = "https://www.eskom.co.za/dataportal/wp-content/uploads/%Y/%m/Station_Build_Up.csv"

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

    def fetch
      if @from.is_a? Date
        url = @from.strftime(URL_FORMAT)
        res = logger.benchmark_info(url) do
          Faraday.get(url)
        end
        @csv = FastestCSV.parse(res.body)
      else
        @csv = FastestCSV.read(@from)
      end
    end

    def points_generation
      fetch
      r = []
      logger.benchmark_info('csv parse') do
        @csv.shift
        @csv.each do |row|
          #Date_Time_Hour_Beginning
          time = Time.strptime(row[0], '%Y-%m-%d %H:%M:%S')
          time = TZ.local_to_utc(time)
          #Thermal_Gen_Excl_Pumping_and_SCO
          r << {country: 'ZA', time:, production_type: 'fossil_coal', value: row[1].to_f*1000}
          #Eskom_OCGT_SCO_Pumping

          #Eskom_Gas_SCO_Pumping

          #Hydro_Water_SCO_Pumping

          #Pumped_Water_SCO_Pumping

          #Thermal_Generation - sum of above. Can be ignored

          #Nuclear_Generation
          r << {country: 'ZA', time:, production_type: 'nuclear', value: row[7].to_f*1000}
          #International_Imports

          #Eskom_OCGT_Generation
          #added to OCGT below
          #Eskom_Gas_Generation
          r << {country: 'ZA', time:, production_type: 'fossil_gas', value: row[10].to_f*1000}
          #Dispatchable_IPP_OCGT
          r << {country: 'ZA', time:, production_type: 'fossil_oil', value: (row[9].to_f+row[11].to_f)*1000}
          #Hydro_Water_Generation
          r << {country: 'ZA', time:, production_type: 'hydro', value: row[12].to_f*1000}
          #Pumped_Water_Generation
          r << {country: 'ZA', time:, production_type: 'hydro_pumped_storage', value: row[13].to_f*1000}
          #IOS_Excl_ILS_and_MLR - Interruption of Supply

          #ILS_Usage - Interruptible Load Shed

          #Manual_Load_Reduction_MLR - MLS = forced load shedding

          #Wind
          r << {country: 'ZA', time:, production_type: 'wind', value: row[17].to_f*1000}
          #PV
          r << {country: 'ZA', time:, production_type: 'solar', value: row[18].to_f*1000}
          #CSP
          r << {country: 'ZA', time:, production_type: 'solar_thermal', value: row[19].to_f*1000}
          #Other_RE
          r << {country: 'ZA', time:, production_type: 'other_renewable', value: row[20].to_f*1000}
        end
      end
      @from = r.first[:time]
      @to = r.last[:time]
      #require 'pry' ; binding.pry

      r
    end
  end
end
