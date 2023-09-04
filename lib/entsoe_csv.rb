module EntsoeCSV
  class BaseCSV
    def self.source_id
      "entsoe"
    end

    def initialize(file)
      logger.info "Processing #{file}"

      m = /^(\d{4})_(\d{2})_/.match(File.basename(file))
      @from = Date.new m[1].to_i, m[2].to_i
      @to = @from + 1.month

      if file =~ /\.zip$/i
        zip_file = Zip::File.open(file)
        @file = zip_file.first.get_input_stream
      else
        @file = File.new(file, 'r')
      end
    end

    def parse_time(row)
      Time.strptime(row[:time], '%Y-%m-%d %H:%M:%S.%L')
    end
    def parse_production_type(row)
      row[:production_type].gsub(/ /,'_').downcase
    end
    def parse_value(row)
      (row[:value].to_f*1000).to_i - (row[:value_negative].to_f*1000).to_i
    end
  end

  class GenerationCSV < BaseCSV
    include SemanticLogger::Loggable
    include Out::Generation

    def points_generation
      r = {}
      logger.benchmark_info("csv parse") do
        areas = {}
        csv = CSV.new(
          @file,
          col_sep: "\t",
          headers: [
            :time, #DateTime
            :_resolution, #ResolutionCode
            :area_internal_id, #AreaCode
            :area_type, #AreaTypeCode
            :area_name, #AreaName
            :area_code, #MapCode
            :production_type, #ProductionType
            :value, #ActualGenerationOutput
            :value_negative, #ActualConsumption
            :_update_time #UpdateTime
          ]
        ).each
        csv.next

        loop do
          row = csv.next
          next if row[:area_type] == 'CTA'
          time = parse_time(row)
          #area_code = row[:area_code]
          production_type = parse_production_type(row)
          value = parse_value(row)
          area_id = areas[row[:area_internal_id]] ||= ::Area.where(internal_id: row[:area_internal_id], source: self.class.source_id).pluck(:id).first
          unless area_id
            require 'pry' ; binding.pry
          end

          k = [time,area_id,production_type]
          if r[k] && r[k][:value] != value
            logger.warn("#{row[:area_internal_id]} #{row[:area_name]} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, production_type:, value:}
        end
        #require 'pry' ; binding.pry
      end

      r.values
    end
  end

  class UnitCSV < BaseCSV
    include SemanticLogger::Loggable
    include Out::Unit

    AREA_CODE_OVERRIDE = {
      'DE_Amprion' => 'DE',
      'DE_TenneT_GER' => 'DE',
      'DE_TransnetBW' => 'DE',
      'DE_50HzT' => 'DE',
      'NIE' => 'GB',
      'UA_IPS' => 'UA',
      'UA_BEI' => 'UA'
    }

    def points
      r = []
      logger.benchmark_info("csv parse") do
        units = {}
        csv = CSV.new(@file,
                          col_sep: "\t",
                          return_headers: false, #always returns headers regardless
                          headers: [
                            :time, #DateTime
                            :_resolution, #ResolutionCode
                            :area_internal_id, #AreaCode
                            :_area_type, #AreaTypeCode
                            :_area_name, #AreaName
                            :area_code, #MapCode
                            :unit_internal_id, #GenerationUnitEIC
                            :unit_name, #PowerSystemResourceName
                            :production_type, #ProductionType
                            :value, #ActualGenerationOutput
                            :value_negative, #ActualConsumption
                            :_capacity, #InstalledGenCapacity
                            :_update_time #UpdateTime
                          ]).each
        csv.next
        loop do
          row = csv.next
          time = parse_time(row)
          unit_name = row[:unit_name].force_encoding('UTF-8')
          unit_id = units[row[:unit_internal_id]]

          unless unit_id
            production_type = ProductionType.find_by!(name: parse_production_type(row))
            unit = ::Unit.find_or_create_by!(internal_id: row[:unit_internal_id]) do |unit|
              unit.name = unit_name
              unit.production_type = production_type
              unit.area = ::Area.find_by(
                code: AREA_CODE_OVERRIDE[row[:area_code]] || row[:area_code],
                source: self.class.source_id
              )
              raise "Missing area #{row[:area_code]} / #{row}" unless unit.area
            end
            unit_id = units[row[:unit_internal_id]] = unit.id

            if unit.name != unit_name
              logger.warn "#{unit.internal_id} Mismatched name #{unit.name} != #{unit_name}"
            end
            if unit.production_type != production_type
              logger.warn "#{unit.name} #{unit.internal_id} Mismatched production_type: #{unit.production_type.name} != #{production_type.name}"
            end
          end

          value = parse_value(row)
          r << {
            unit_id:,
            time:,
            value:
          }
        end
      end

      r
    end
  end

  class PriceCSV < BaseCSV
    include SemanticLogger::Loggable
    include Out::Price

    def points_price
      r = {}
      logger.benchmark_info("csv parse") do
        areas = {}
        csv = CSV.new(@file,
                      col_sep: "\t",
                      return_headers: false,
                      headers: [
                        :time, #DateTime
                        :resolution, #ResolutionCode
                        :area_internal_id, #AreaCode
                        :_area_type, #AreaTypeCode
                        :area_name, #AreaName
                        :area_code, #MapCode
                        :price, #Price
                        :currency, #Curency
                        :_update_time #UpdateTime
                      ]).each
        csv.next
        loop do
          row = csv.next
          next if row[:resolution] != 'PT60M'

          time =  parse_time(row)
          area_id = areas[row[:area_internal_id]] ||= ::Area.where(internal_id: row[:area_internal_id], source: self.class.source_id).pluck(:id).first
          value = row[:price].to_f
          unless area_id
            require 'pry' ; binding.pry
          end
          k = [time,area_id]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{row[:area_internal_id]} #{row[:area_name]} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end
end
