require 'open-uri'

module Nyiso
  class Base
    def self.source_id
      "nyiso"
    end
    def points
      r = []
      fuel_sums.each do |type, v|
        v.each do |time, value|
          r << {
            time: time,
            production_type: type,
            country: 'US-NY',
            value: value
          }
        end
      end

      #require 'pry' ; binding.pry
      r
    end
  end
  class Generation
    def initialize
      HTTParty.get("http://mis.nyiso.com/public/csv/rtfuelmix/#{date.strftime('%Y%m%d')}rtfuelmix.csv")
    end
  end
  class GenerationMonth < Base
    FUEL_MAP = {
      'Dual Fuel' => 'fossil_gas',
      'Natural Gas' => 'fossil_gas',
      'Nuclear' => 'nuclear',
      'Other Fossil Fuels' => 'other',
      'Other Renewables' => 'other_renewable',
      'Wind' => 'wind_onshore',
      'Hydro' => 'hydro_run-of-river_and_poundage',
    }
    def initialize(date)
      @uri = URI.open("http://mis.nyiso.com/public/csv/rtfuelmix/#{date.strftime('%Y%m%d')}rtfuelmix_csv.zip")
      @zip = Zip::File.open_buffer(@uri)
    end
    def fuel_sums
      fuel_sums = {}
      @zip.entries.each do |f|
        f.get_input_stream do |io|
          CSV.new(io, skip_lines: /^Time Stamp/).each do |row|
            time = DateTime.strptime(row[0]+row[1], '%m/%d/%Y %H:%M:%S%Z')
            type = FUEL_MAP[row[2]]
            value = row[3].to_f
            out_sum = fuel_sums[type] ||= {}
            out_sum[time] ||= 0.0
            out_sum[time] += value
            #require 'pry' ; binding.pry
          end
        end
      end

      fuel_sums
    end
  end
end
