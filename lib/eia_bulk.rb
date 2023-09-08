module EiaBulk
  class Base
    def self.source_id
      "eia"
    end
    def initialize(path)
      if path =~ /\.zip$/i
        zip_file = Zip::File.open(path)
        @file = zip_file.first.get_input_stream
      else
        @file = File.open(path, 'r')
      end
    end
  end

  class EBA < Base
    DATE_FORMAT = '%Y%m%dT%H%z'
    def parse_time(s)
      Time.strptime(s, DATE_FORMAT) - 1.hour
    end
    def parse_from_to(json)
      [
        Time.strptime(json[:start], DATE_FORMAT),
        Time.strptime(json[:end], DATE_FORMAT) # up to and including
      ]
    end

    def process
      @file.each_line do |line|
        next if line[0] == '\r'
        json = FastJsonparser.parse(line, symbolize_keys: true)
        # series_id
        if json[:series_id]
          puts "S #{json[:series_id]} #{json[:name]}"
          series = json[:series_id].split /\./
          case series[2]
          when 'D' # Demand
            process_demand(series, json)

          when 'NG' # Net generation
            next
            process_generation(series, json)

          when 'ID' # Actual Net interchange
            # 0   1         2
            # EBA.CISO-AZPS.ID.H
            next
          when 'DF' # Day-ahead demand forecast
          when 'TI' # Total interchange
          else
            raise series[2]
          end
          #next if json[:series_id] =~ /^ELEC\.PLANT/
        elsif json[:category_id]
          #puts "C #{json[:category_id]} #{json[:name]}"
        elsif json[:geoset_id]
          #puts "G #{json[:name]}"
        elsif json[:relation_id]
          #next if json[:series_id] =~ /^ELEC\.SULFUR/
          #puts "R #{json[:relation_id]} #{json[:name]}"
        else
          require 'pry' ; binding.pry
        end
        # data
      end
    end

    def process_demand(series, json)
      # 0   1      2 3
      # EBA.SW-ALL.D.H
      timezone = series[3]
      unless timezone == 'H'
        puts "skip timezone"
        return
      end

      country, country_suffix = series[1].split(/-/)
      if country_suffix != 'ALL'
        puts "skip country"
        return
      end

      from, to = parse_from_to(json)

      r = json[:data].map! do |p|
        next nil unless p[1]
        value = p[1]*1000
        time = parse_time(p[0])

        {
          time:,
          country:,
          value:
        }
      end
      r.compact!
      Out2::Load.run(r, from, to, self.class.source_id)
    end

    def process_generation(series, json)
      # 0   1        2  3   4
      # EBA.US48-ALL.NG.H
      # EBA.CISO-ALL.NG.SUN.H
      unless series.length == 5
        puts "skip series"
        return
      end

      timezone = series[4]
      unless timezone == 'H'
        puts "skip timezone"
        return
      end

      country, country_suffix = series[1].split(/-/)
      if country_suffix != 'ALL'
        puts "skip country"
        return
      end

      production_type = Eia::Base::FUEL_MAP[series[3]]
      from, to = parse_from_to(json)

      r = json[:data].map! do |p|
        next nil unless p[1]
        value = p[1]*1000
        time = parse_time(p[0])

        {
          time:,
          country:,
          production_type:,
          value:
        }
      end
      r.compact!
      Out2::Generation.run(r, from, to, self.class.source_id)
    end
  end

  class ELEC < Base
  end
end
