require 'zip'
require 'fastest_csv'

module EntsoeCsv
  class BaseFastestCSV
    def self.source_id
      "entsoe"
    end

    def initialize(file_or_io, name_if_io = nil, time_if_io = nil, zip = false)
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

        if zip || @filename =~ /\.zip$/i
          zip = Zip::File.open_buffer(file_or_io) do |io|
            @file = StringIO.new(io.entries.first.get_input_stream.read)
          end
        else
          @file = file_or_io
        end
      end
      #require 'pry' ; binding.pry

      parse_filename
    end

    def parse_filename
      m = /^(\d{4})_(\d{2})_/.match(@filename)
      @from = Date.new m[1].to_i, m[2].to_i
      @to = @from + 1.month
    end

    PT_MAP = {
      'energy_storage' => 'storage'
    }
    def parse_production_type(s)
      pt = s.strip.gsub(/ /,'_').downcase

      PT_MAP[pt] || pt
    end

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S.%L'
    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = Time.strptime(s, self.class::TIME_FORMAT)
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

      value.to_i
    end

    def csv
      FastestCSV.new(@file, col_sep: "\t", skip_header: true) #.enum_for(:each)
    end

    def done!
      DataFile.upsert({path: @filename, source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{@filename}"
    end
  end

  class GenerationCSV < BaseFastestCSV
    include SemanticLogger::Loggable
    include Out::Generation

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def points_generation
      r = {}
      logger.benchmark_info("csv parse") do
        #require 'pry' ; binding.pry
        csv.each do |row|
          next if row[4] == 'CTA'

          #0:DateTime(UTC)
          time = parse_time(row[0])
          #1:ResolutionCode
          #2:AreaCode
          country = row[2]
          #3:AreaDisplayName
          #4:AreaTypeCode
          #5:AreaMapCode
          #6:ProductionType
          production_type = parse_production_type(row[6])
          #7:ActualGenerationOutput[MW]
          #8:ActualConsumption[MW]
          #9:UpdateTime(UTC)
          value = parse_value(row[7], row[8])
          #9:UpdateTime

          #area_code = row[:area_code]

          k = [time,country,production_type]
          if r[k] && r[k][:value] != value
            logger.warn("#{country} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, country:, production_type:, value:}
        end
      end
      #require 'pry';binding.pry

      Validate.validate_generation(r.values, self.class.source_id)
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
      r = {}
      r_cap = {}
      logger.benchmark_info("csv parse") do
        csv
        units = {}
        csv.each do |row|
          #0:DateTime(UTC)
          time = parse_time(row[0])
          #1:ResolutionCode
          #2:AreaCode
          #3:AreaDisplayName
          #4:AreaTypeCode
          #5:MapCode
          area_code = row[5]
          #6:GenerationUnitCode
          unit_internal_id = row[6]
          #7:GenerationUnitName
          unit_name = row[7].force_encoding('UTF-8')
          #8:GenerationUnitType
          production_type = parse_production_type(row[8])
          #9:ActualGenerationOutput(MW)
          #10:ActualConsumption(MW)
          value = parse_value(row[9], row[10])
          #11:GenerationUnitInstalledCapacity(MW)
          capacity = parse_value(row[11])
          #12:UpdateTime(UTC)

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
              logger.warn "#{unit.internal_id} Mismatched name old #{unit.name.inspect} != new #{unit_name.inspect}"
            end
            if unit.production_type != production_type
              logger.warn "#{unit.name} #{unit.internal_id} Mismatched production_type: old #{unit.production_type.name} != new #{production_type.name}"
            end
          end

          k = [time, unit_id]
          if r[k] && value != r[k][:value]
            logger.error "duplicate data with different output #{unit_internal_id} #{value} != #{r[k][:value]}"
          end
          if r_cap[k] && capacity != r_cap[k][:value]
            logger.error "duplicate data with different capacites #{unit_internal_id} #{capacity} != #{r_cap[k][:value]}"
          end
          r[k] = {unit_id:, time:, value:}
          r_cap[k] = {unit_id:, time:, value: capacity}
        end
      end
      Out2::UnitCapacity.run(r_cap.values, @from, @to, self.class.source_id)

      r.values
    end
  end

  class LoadCSV < BaseFastestCSV
    include SemanticLogger::Loggable
    include Out::Load

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def points_load
      r = {}
      logger.benchmark_info("csv parse") do
        csv
        csv.each do |row|
          next if row[4] == 'CTA'
          #0:DateTime(UTC)
          time = parse_time(row[0])
          #1:ResolutionCode
          #2:AreaCode
          area_id = parse_area(row[2])
          #3:AreaDisplayName
          area_name = row[3]
          #4:AreaTypeCode
          #5:AreaMapCode
          area_code = row[5]
          #6:TotalLoad[MW]
          value = row[6].to_f*1000
          #7:UpdateTime(UTC)

          k = [time,area_id]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{area_name} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      Validate::validate_load(r.values, self.class.source_id)
    end
  end

  class PriceCSV < BaseFastestCSV
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def initialize(file_or_io, name_if_io = nil, time_if_io = nil, zip = false)
      super
      @first_s = {}
    end

    def process
      first_s = []
      r = {}
      logger.benchmark_info("csv parse") do
        csv.each do |row|
          #0: InstanceCode
          #1: DateTime(UTC)
          time = parse_time(row[1])
          #2: ResolutionCode
          #3: AreaCode
          area_id = parse_area(row[3])
          #4: AreaDisplayName
          #5: AreaTypeCode
          #6: MapCode
          #7: ContractType
          next unless row[7] == 'Day-ahead'
          #8: Sequence
          next unless row[8].blank? || row[8] == '1'
          #9; Price[Currency/MWh]
          value = row[9].to_f*100
          #10: Currency
          #11: UpdateTime(UTC)

          k = [time,area_id]
          if r[k] && r[k][:value] != value
            logger.warn("#{time} #{area_id} different values #{r[k][:value]} != #{value}")
          end
          r[k] = {time:, area_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      ::Out2::Price.run(r.values, @from, @to, self.class.source_id)
      done!
    end
  end

  class CapacityCSV < BaseFastestCSV
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y %Z'
    def parse_filename
      #sets @from and @to
    end
    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = DateTime.strptime(s, self.class::TIME_FORMAT).to_time
    end

    def points_capacity
      r = {}
      logger.benchmark_info("csv parse") do
        csv.each do |row|
          #0: Year
          #1: TimeZone
          time = parse_time("#{row[0]} #{row[1]}")
          #2: ResolutionCode
          raise row[2] unless row[2] == 'P1Y'
          #3: AreaCode
          next if row[5] == 'CTA'
          area_id = parse_area(row[3])
          #4: AreaDisplayName
          #5: AreaTypeCode
          #6: AreaMapCode
          #7: ProductionType
          production_type = parse_production_type(row[7])

          #8: AggregatedInstalledCapacity[MW]
          value = row[8].to_f*1000

          #9: UpdateTime(UTC)
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

  class UnitCapacityCSV < BaseFastestCSV
    include SemanticLogger::Loggable

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

    #Production and Generation units have different EIC codes making the output of this small
    #EIC parent of production unit = generation unit EIC
    #Map can be found on https://www.entsoe.eu/data/energy-identification-codes-eic/eic-approved-codes/
    # EIC Type Code = Resource Object W
    def points_unit_capacity
      r={}
      logger.benchmark_info("csv parse") do
        csv.each do |row|
          #0: EICCode
          unit = Unit.includes(:area).where(area: {source:'entsoe'}).find_by(internal_id: row[0])
          unless unit
            puts "Missing #{row[6]}/#{row[1]}"
            require 'pry' ; binding.pry
          end
          next unless unit
          #1: Name
          #2: ValidFrom
          time = parse_time(row[2])
          #3: ValidTo
          #4: Status
          #5: Type
          #6: Location
          #7: InstalledCapacity
          value = row[7].to_f*1000
          #8: ControlArea
          #9: BiddingZone
          #10: Voltage

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

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

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

    AREA_TYPE_MAP = {
      'BZN/CTA/CTY' => :country,
      'CTY' => :country,
      'BZN' => :zone,
    }
    def points
      r = {}
      logger.benchmark_info("csv parse") do
        csv.each do |row|
          next if row[4] == 'CTA' || row[8] == 'CTA'

          #0:DateTime(UTC)
          time = parse_time(row[0])
          #1:ResolutionCode
          #2:OutAreaCode
          to_area_internal_id = row[2]
          #3:OutAreaDisplayName
          #4:OutAreaTypeCode
          to_area_type = AREA_TYPE_MAP[row[4]]
          #5:OutAreaMapCode
          to_area_code = row[5]
          to_area_id = parse_area(to_area_internal_id, {type: to_area_type, code: to_area_code})

          #6:InAreaCode
          from_area_internal_id = row[6]
          #7:InAreaDisplayName
          #8:InAreaTypeCode
          from_area_type = AREA_TYPE_MAP[row[8]]
          #9:InAreaMapCode
          from_area_code = row[9]
          from_area_id = parse_area(from_area_internal_id, {type: from_area_type, code: from_area_code})

          #10:Flow[MW]
          value = (row[10].to_f*1000).to_i
          #11:UpdateTime(UTC)

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
