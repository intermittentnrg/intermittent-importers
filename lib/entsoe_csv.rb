require 'zip'
require 'csv'
require 'fastest_csv'

module EntsoeCsv
  class BaseCSV
    def self.source_id
      "entsoe"
    end

    def initialize(file_or_io, name_if_io = nil, time_if_io = nil)
      @areas = {}
      if file_or_io.is_a?(String) # url
        raise if name_if_io || time_if_io
        logger.info "Processing #{file_or_io}"

        @filename = File.basename(file_or_io)
        @filedate = File.mtime(file_or_io)

        if @filename =~ /\.zip$/i
          zip_file = Zip::File.open(file_or_io)
          @file = zip_file.first.get_input_stream
        else
          @file = File.new(file_or_io, 'r')
        end
      else
        @filename = name_if_io
        @filedate = time_if_io

        if @filename =~ /\.zip$/i
          zip = Zip::File.open_buffer(file_or_io) do |io|
            @file = StringIO.new(io.entries.first.get_input_stream.read)
          end
        else
          @file = file_or_io
        end
      end
      @previous_filedate = DataFile.where(path: @filename, source: self.class.source_id).pluck(:updated_at)[0]
      #require 'pry' ; binding.pry

      parse_filename
    end

    def csv
      @csv = CSV.new(@file,
                     col_sep: "\t",
                     liberal_parsing: true,
                     headers: self.class::HEADERS).each
      @csv.next
    end

    def parse_filename
      m = /^(\d{4})_(\d{2})_/.match(@filename)
      @from = Date.new m[1].to_i, m[2].to_i
      @to = @from + 1.month
    end

    def parse_time(row)
      s = row[:time]
      return @last_t if @last_s == s

      @last_s = s
      @last_t = Time.strptime(s, '%Y-%m-%d %H:%M:%S.%L')
    end
    def parse_area(row, k = :area_internal_id)
      area_id = @areas[row[k]] ||= ::Area.where(internal_id: row[k], source: self.class.source_id).pluck(:id).first
      unless area_id
        if k == :out_area_internal_id
          area = Area.new internal_id: row[k], code: row[:out_area_name].gsub(/ /, '-'), type: row[:out_area_type] == 'CTY' ? 'country' : 'zone', region: 'europe', source: self.class.source_id
        elsif k == :in_area_internal_id
          area = Area.new internal_id: row[k], code: row[:in_area_name].gsub(/ /, '-'), type: row[:in_area_type] == 'CTY' ? 'country' : 'zone', region: 'europe', source: self.class.source_id
        end
        require 'pry' ; binding.pry
        area.save!
        area_id = @areas[row[k]] = area.id
      end

      area_id
    end
    def parse_production_type(row)
      row[:production_type].gsub(/ /,'_').downcase
    end
    def parse_value(row)
      (row[:value].to_f*1000).to_i - (row[:value_negative].to_f*1000).to_i
    end
    def done!
      DataFile.upsert({path: @filename, source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{@filename}"
    end
  end

  class BaseFastestCSV < BaseCSV
    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = Time.strptime(s, '%Y-%m-%d %H:%M:%S.%L')
    end

    def parse_production_type(s)
      s.gsub(/ /,'_').downcase
    end

    def parse_area(s, fields = {})
      area_id = @areas[s] ||= ::Area.where(internal_id: s, source: self.class.source_id).pluck(:id).first
      unless area_id
        area = Area.new({
                          internal_id: s,
                          region: 'europe',
                          source: self.class.source_id,
                          enabled: false
                        }.merge(fields))
        require 'pry' ; binding.pry
        area.save!
        area_id = @areas[s] = area.id
      end

      area_id
    end

    def parse_value(s, s_neg = nil)
      value = (s.to_f*1000)
      value -= (s_neg.to_f*1000) if s_neg

      value
    end

    def csv
      FastestCSV.new(@file, col_sep: "\t", skip_header: true) #.enum_for(:each)
    end
  end

  class GenerationCSV < BaseFastestCSV
    include SemanticLogger::Loggable
    include Out::Generation

    def points_generation
      r = {}
      logger.benchmark_info("csv parse") do
        csv
        #require 'pry' ; binding.pry
        csv.each do |row|
          next if row[3] == 'CTA'
          next if @previous_filedate.present? && parse_time(row[9]) < @previous_filedate

          #DateTime
          time = parse_time(row[0])
          #ResolutionCode
          #AreaCode
          area_id = parse_area(row[2])
          #AreaTypeCode
          #AreaName
          area_name = row[4]
          #MapCode
          #ProductionType
          production_type = parse_production_type(row[6])
          #ActualGenerationOutput
          #ActualConsumption
          value = parse_value(row[7], row[8])
          #9:UpdateTime

          #area_code = row[:area_code]

          k = [time,area_id,production_type]
          if r[k] && r[k][:value] != value
            logger.warn("#{area_name} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, production_type:, value:}
        end
      end
      #require 'pry';binding.pry

      Validate.validate_generation(r.values)
    end
  end

  class UnitCSV < BaseFastestCSV
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
      r_cap = []
      logger.benchmark_info("csv parse") do
        csv
        units = {}
        csv.each do |row|
          next if @previous_filedate.present? && parse_time(row[12]) < @previous_filedate
          #0:DateTime
          time = parse_time(row[0])
          #1:ResolutionCode
          #2:AreaCode
          #3:AreaTypeCode
          #4:AreaName
          #5:MapCode
          area_code = row[5]
          #6:GenerationUnitEIC
          unit_internal_id = row[6]
          #7:PowerSystemResourceName
          unit_name = row[7].force_encoding('UTF-8')
          #8:ProductionType
          production_type = parse_production_type(row[8])
          #9:ActualGenerationOutput
          #10:ActualConsumption
          value = parse_value(row[9], row[10])
          #11:InstalledGenCapacity
          capacity = parse_value(row[11])
          #12:UpdateTime

          unit_id = units[unit_internal_id]
          unless unit_id
            production_type = ProductionType.find_by!(name: production_type)
            unit = ::Unit.find_or_create_by!(internal_id: unit_internal_id) do |unit|
              unit.name = unit_name
              unit.production_type = production_type
              unit.area = ::Area.find_by(
                code: AREA_CODE_OVERRIDE[area_code] || area_code,
                source: self.class.source_id
              )
              raise "Missing area #{area_code} / #{row}" unless unit.area
            end
            unit_id = units[unit_internal_id] = unit.id

            if unit.name != unit_name
              logger.warn "#{unit.internal_id} Mismatched name #{unit.name} != #{unit_name}"
            end
            if unit.production_type != production_type
              logger.warn "#{unit.name} #{unit.internal_id} Mismatched production_type: #{unit.production_type.name} != #{production_type.name}"
            end
          end

          r << {unit_id:, time:,value:}
          r_cap << {unit_id:, time:, value: capacity}
        end
      end
      Out2::UnitCapacity.run(r_cap, @from, @to, self.class.source_id)

      r
    end
  end

  class LoadCSV < BaseFastestCSV
    include SemanticLogger::Loggable
    include Out::Load

    def points_load
      r = {}
      logger.benchmark_info("csv parse") do
        csv
        csv.each do |row|
          next if row[3] == 'CTA'
          next if @previous_filedate.present? && parse_time(row[7]) < @previous_filedate
          #DateTime
          time = parse_time(row[0])
          #ResolutionCode
          #AreaCode
          area_id = parse_area(row[2])
          #AreaTypeCode
          #AreaName
          area_name = row[4]
          #MapCode
          area_code = row[5]
          #TotalLoadvalue
          value = row[6].to_f*1000
          #7:UpdateTime

          k = [time,area_id]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{area_name} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      Validate::validate_load(r.values)
    end
  end

  class PriceCSV < BaseFastestCSV
    include SemanticLogger::Loggable
    include Out::Price

    def points_price
      r = {}
      logger.benchmark_info("csv parse") do
        csv.each do |row|
          next if row[1] != 'PT60M'
          next if @previous_filedate.present? && parse_time(row[8]) < @previous_filedate
          #DateTime
          time = parse_time(row[0])
          #ResolutionCode
          #AreaCode
          area_id = parse_area(row[2])
          #AreaTypeCode
          #AreaName
          area_name = row[4]
          #MapCode
          #Price
          value = row[6].to_f*100
          #Curency
          #8:UpdateTime

          k = [time,area_id]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{area_name} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end

  class CapacityCSV < BaseCSV
    include SemanticLogger::Loggable
    #include Out::Price

    HEADERS = [
      :time, #DateTime
      :resolution, #ResolutionCode
      :area_internal_id, #AreaCode
      :area_type, #AreaTypeCode
      :area_name, #AreaName
      :area_code, #MapCode
      :production_type, #ProductionType
      :capacity, #AggregatedInstalledCapacity
      :deleted, #DeletedFlag
      :update_time #UpdateTime
    ]

    def points_capacity
      r = {}
      csv
      logger.benchmark_info("csv parse") do
        loop do
          row = @csv.next
          next if row[:area_type] == 'CTA'
          time = parse_time(row)
          area_id = parse_area(row)
          value = row[:capacity].to_f*1000
          production_type = parse_production_type(row)
          k = [area_id,production_type,time]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{row[:area_internal_id]} #{row[:area_name]} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, production_type:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end
    def process
      Out2::Capacity.run(points_capacity, nil, nil, self.class.source_id)
      done!
    end
  end

  class UnitCapacityCSV < BaseCSV
    include SemanticLogger::Loggable

    HEADERS = [
      :internal_id, #EICCode
      :name, # Name
      :valid_from, # ValidFrom
      :valid_to, # ValidTo
      :status, # Status
      :type, # Type
      :location, # Location
      :value, # InstalledCapacity
      :_cta, # ControlArea
      :area_id, # BiddingZone
      :_voltage # Voltage
    ]

    def self.cli(args)
      if args.empty?
        $stderr.puts "#{$0} [file]"
        exit 1
      end

      args.each do |file|
        e = EntsoeCsv::UnitCapacityCSV.new(file)
        e.process
      end
    end

    def parse_filename
    end

    def points_unit_capacity
      r={}
      csv
      logger.benchmark_info("csv parse") do
        loop do
          row = @csv.next
          time = Time.strptime(row[:valid_from], '%Y-%m-%d %H:%M:%S.%L')
          unit = Unit.includes(:area).where(area: {source:'entsoe'}).find_by(internal_id: row[:internal_id])
          next unless unit
          value = row[:value].to_f*1000

          k = [unit.id, time]
          if r[k]
            require 'pry' ; binding.pry
          end
          r[k] = {unit_id: unit.id, time:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end

    def process
      Out2::UnitCapacity.run(points_unit_capacity, @from, @to, self.class.source_id)
      done!
    end
  end

  class TransmissionCSV < BaseFastestCSV
    include SemanticLogger::Loggable
    include Out::Transmission

    def self.cli(args)
      if args.empty?
        $stderr.puts "#{$0} [file ...]"
        exit 1
      end

      args.each do |file|
        e = EntsoeCsv::TransmissionCSV.new(file)
        e.process
      end
    end

    HEADERS = [
      :time, #DateTime
      :resolution, #ResolutionCode
      :out_area_internal_id, #OutAreaCode
      :out_area_type, #OutAreaTypeCode
      :out_area_name, #OutAreaName
      :out_area_code, #OutMapCode
      :in_area_internal_id, #InAreaCode
      :in_area_type, #InAreaTypeCode
      :in_area_name, #InAreaName
      :in_area_code, #InMapCode
      :value, #FlowValue
      :_update_time #UpdateTime
    ]
    AREA_TYPE_MAP = {
      'BZN' => :zone,
      'CTY' => :country
    }
    def points
      r = {}
      logger.benchmark_info("csv parse") do
        csv.each do |row|
          next if row[3] == 'CTA' || row[7] == 'CTA'
          next if @previous_filedate.present? && parse_time(row[11]) < @previous_filedate

          #DateTime
          time = parse_time(row[0])
          #ResolutionCode
          #2:OutAreaCode
          to_area_internal_id = row[2]
          #3:OutAreaTypeCode
          to_area_type = AREA_TYPE_MAP[row[3]]
          #4:OutAreaName
          to_area_code = row[4]
          #5:OutMapCode
          to_area_id = parse_area(to_area_internal_id, {type: to_area_type, code: to_area_code})

          #6:InAreaCode
          from_area_internal_id = row[6]
          #7:InAreaTypeCode
          from_area_type = AREA_TYPE_MAP[row[7]]
          #8:InAreaName
          from_area_code = row[8]
          #9:InMapCode

          from_area_id = parse_area(from_area_internal_id, {type: from_area_type, code: from_area_code})

          #FlowValue
          value = (row[10].to_f*1000).to_i
          #11:UpdateTime

          k = [to_area_id,from_area_id,time]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{to_area_code} - #{from_area_code} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, to_area_id:, from_area_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end
end
