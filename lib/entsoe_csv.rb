# frozen_string_literal: true

require 'zip'
require 'fastest_csv'

module EntsoeCsv
  class Base
    include SemanticLogger::Loggable
    BATCH_SIZE = 500_000

    def self.source_id
      'entsoe'
    end

    def self.cli(args)
      if args.empty?
        warn "#{$PROGRAM_NAME} [file ...]"
        exit 1
      end

      args.each do |file|
        new.add_file(file).done!
      end
    end

    def initialize
      @areas = {}
      @datafiles = []
      @r = {}
    end

    def add_file(path, name = nil, time = nil, zip = false)
      name ||= File.basename(path)
      time ||= File.mtime(path)
      tmp = nil

      logger.benchmark_info "Processing #{name}" do
        parse_filename(name)

        if zip || path.ends_with?('.zip')
          logger.benchmark_info("unzip #{path}") do
            tmp = Tempfile.new(['entsoe', '.csv'])
            Zip::File.open(path) do |zip_file|
              zip_file.first.get_input_stream do |stream|
                IO.copy_stream(stream, tmp)
              end
            end
            tmp.close
            path = tmp.path
          end
        end
        logger.benchmark_info("csv parse #{path}") do
          FastestCSV.foreach(path, col_sep: "\t", skip_header: true) do |row|
            add_row(row)
            flush if @r.size >= self.class::BATCH_SIZE
          end
        end
        tmp.unlink if zip
        @datafiles << { path: name, source: self.class.source_id, updated_at: time }
      end

      self
    end

    def add_buffer(body, name, time)
      logger.benchmark_info "Processing #{name}" do
        parse_filename(name)

        csv = FastestCSV.parse(body, col_sep: "\t", skip_header: true)
        csv.each { |row| add_row(row) }

        @datafiles << { path: name, source: self.class.source_id, updated_at: time }
      end

      self
    end

    def done!
      flush
      DataFile.upsert_all(@datafiles, unique_by: %i[source path])
      logger.info "done! #{@datafiles.first[:path]}"
    end

    def parse_filename(name)
      m = /^(\d{4})_(\d{2})_/.match(name)
      @from = Date.new m[1].to_i, m[2].to_i
      @to = @from + 1.month
    end

    PT_MAP = {
      'energy_storage' => 'storage'
    }.freeze
    def parse_production_type(s)
      pt = s.strip.gsub(/ /, '_').downcase

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
        require 'pry'
        binding.pry
        area.save!
        area_id = @areas[s] = area.id
      end

      area_id
    end

    def parse_value(s, s_neg = nil)
      value = (s.to_f * 1000)
      value -= (s_neg.to_f * 1000) if s_neg

      value.to_i
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def add_row(row)
      return if row[4] == 'CTA'

      # 0:DateTime(UTC)
      time = parse_time(row[0])
      # 1:ResolutionCode
      # 2:AreaCode
      country = row[2]
      # 3:AreaDisplayName
      # 4:AreaTypeCode
      # 5:AreaMapCode
      # 6:ProductionType
      production_type = parse_production_type(row[6])
      # 7:ActualGenerationOutput[MW]
      # 8:ActualConsumption[MW]
      # 9:UpdateTime(UTC)
      value = parse_value(row[7], row[8])
      # 9:UpdateTime

      # area_code = row[:area_code]

      k = [time, country, production_type]
      logger.warn("#{country} different values #{@r[k][:value]} != #{value}") if @r[k] && @r[k][:value] != value
      @r[k] = { time:, country:, production_type:, value: }
    end

    def flush
      r = Validate.validate_generation(@r.values, self.class.source_id)
      Out::Generation.run(r, @from, @to, self.class.source_id)
      @r = {}
    end
  end

  class Unit < Base
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    AREA_CODE_OVERRIDE = {
      'DE_Amprion' => 'DE',
      'DE_TenneT_GER' => 'DE',
      'DE_TransnetBW' => 'DE',
      'DE_50HzT' => 'DE',
      'NIE' => 'GB',
      'UA_IPS' => 'UA',
      'UA_BEI' => 'UA'
    }.freeze

    def initialize
      super
      @units = {}
    end

    def add_row(row)
      # 0:DateTime(UTC)
      time = parse_time(row[0])
      # 1:ResolutionCode
      # 2:AreaCode
      area_code = row[2]
      # 3:AreaDisplayName
      # 4:AreaTypeCode
      # 5:AreaMapCode
      # 6:GenerationUnitCode
      unit_internal_id = row[6]
      # 7:GenerationUnitName
      unit_name = row[7].force_encoding('UTF-8')
      # 8:GenerationUnitType
      production_type = parse_production_type(row[8])
      # 9:ActualGenerationOutput[MW]
      # 10:ActualConsumption[MW]
      value = parse_value(row[9], row[10])
      # 11:UpdateTime(UTC)

      unit_id = @units[unit_internal_id]
      unless unit_id
        production_type = ProductionType.find_by!(name: production_type)
        unit = ::Unit.find_or_create_by!(internal_id: unit_internal_id) do |unit|
          unit.name = unit_name
          unit.production_type = production_type
          unit.area = ::Area.find_by(
            internal_id: AREA_CODE_OVERRIDE[area_code] || area_code,
            source: self.class.source_id
          )
          raise "Missing area #{area_code} / #{row}" unless unit.area
        end
        unit_id = @units[unit_internal_id] = unit.id

        if unit.name != unit_name
          logger.warn "#{unit.internal_id} Mismatched name old #{unit.name.inspect} != new #{unit_name.inspect}"
        end
        if unit.production_type != production_type
          logger.warn "#{unit.name} #{unit.internal_id} Mismatched production_type: old #{unit.production_type.name} != new #{production_type.name}"
        end
      end

      k = [time, unit_internal_id]
      if @r[k] && value != @r[k][:value]
        logger.error "duplicate data with different output #{unit_internal_id} #{value} != #{@r[k][:value]}"
      end
      @r[k] = { unit_id:, time:, value: }
    end

    def flush
      Out::Unit.run(@r.values, @from, @to, self.class.source_id)
      @r = {}
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def add_row(row)
      return if row[4] == 'CTA'

      # 0:DateTime(UTC)
      time = parse_time(row[0])
      # 1:ResolutionCode
      # 2:AreaCode
      country = row[2]
      # 3:AreaDisplayName
      area_name = row[3]
      # 4:AreaTypeCode
      # 5:AreaMapCode
      # 6:TotalLoad[MW]
      value = row[6].to_f * 1000
      # 7:UpdateTime(UTC)

      k = [time, country]
      if @r[k] && @r[k][:value] != value
        logger.warn("#{time} #{area_name} different values #{@r[k][:value]} != #{value}")
      end
      @r[k] = { time:, country:, value: }
    end

    def flush
      r = Validate.validate_load(@r.values, self.class.source_id)
      Out::Load.run(r, @from, @to, self.class.source_id)
      @r = {}
    end
  end

  class Price < Base
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    def initialize
      super
      @first_s = {}
    end

    def add_row(row)
      # 0: InstanceCode
      # 1: DateTime(UTC)
      time = parse_time(row[1])
      # 2: ResolutionCode
      # 3: AreaCode
      area_id = parse_area(row[3])
      # 4: AreaDisplayName
      # 5: AreaTypeCode
      # 6: MapCode
      # 7: ContractType
      return unless row[7] == 'Day-ahead'

      # 8: Sequence
      return unless row[8].blank? || row[8] == '1'

      # 9; Price[Currency/MWh]
      value = row[9].to_f * 100
      # 10: Currency
      # 11: UpdateTime(UTC)

      k = [time, area_id]
      logger.warn("#{time} #{area_id} different values #{@r[k][:value]} != #{value}") if @r[k] && @r[k][:value] != value
      @r[k] = { time:, area_id:, value: }
    end

    def flush
      ::Out::Price.run(@r.values, @from, @to, self.class.source_id)
      @r = {}
    end
  end

  class UnitCapacity < Base
    include SemanticLogger::Loggable

    def parse_filename; end

    # Production and Generation units have different EIC codes making the output of this small
    # EIC parent of production unit = generation unit EIC
    # Map can be found on https://www.entsoe.eu/data/energy-identification-codes-eic/eic-approved-codes/
    # EIC Type Code = Resource Object W
    def add_row(row)
      # 0: EICCode
      unit = ::Unit.includes(:area).where(area: { source: 'entsoe' }).find_by(internal_id: row[0])
      unless unit
        puts "Missing #{row[6]}/#{row[1]}"
        require 'pry'
        binding.pry
      end
      return unless unit

      # 1: Name
      # 2: ValidFrom
      time = parse_time(row[2])
      # 3: ValidTo
      # 4: Status
      # 5: Type
      # 6: Location
      # 7: InstalledCapacity
      value = row[7].to_f * 1000
      # 8: ControlArea
      # 9: BiddingZone
      # 10: Voltage

      k = [unit.id, time]
      if @r[k]
        require 'pry'
        binding.pry
      end
      @r[k] = { unit_id: unit.id, time:, value: }
    end

    def flush
      Out::UnitCapacity.run(@r.values, @from, @to, self.class.source_id)
      @r = {}
    end
  end

  class Transmission < Base
    include SemanticLogger::Loggable

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    AREA_TYPE_MAP = {
      'BZN/CTA/CTY' => :country,
      'CTY' => :country,
      'BZN' => :zone
    }.freeze

    def add_row(row)
      return if row[4] == 'CTA' || row[8] == 'CTA'

      # 0:DateTime(UTC)
      time = parse_time(row[0])
      # 1:ResolutionCode
      # 2:OutAreaCode
      to_area_internal_id = row[2]
      # 3:OutAreaDisplayName
      # 4:OutAreaTypeCode
      to_area_type = AREA_TYPE_MAP[row[4]]
      # 5:OutAreaMapCode
      to_area_code = row[5]
      to_area_id = parse_area(to_area_internal_id, { type: to_area_type, code: to_area_code })

      # 6:InAreaCode
      from_area_internal_id = row[6]
      # 7:InAreaDisplayName
      # 8:InAreaTypeCode
      from_area_type = AREA_TYPE_MAP[row[8]]
      # 9:InAreaMapCode
      from_area_code = row[9]
      from_area_id = parse_area(from_area_internal_id, { type: from_area_type, code: from_area_code })

      # 10:Flow[MW]
      value = (row[10].to_f * 1000).to_i
      # 11:UpdateTime(UTC)

      k = [to_area_id, from_area_id, time]
      if @r[k] && @r[k][:value] != value
        logger.warn("#{time} #{to_area_code} - #{from_area_code} different values #{@r[k][:value]} != #{value}")
      end
      @r[k] = { time:, to_area_id:, from_area_id:, value: }
    end

    def flush
      Out::Transmission.run(@r.values, @from, @to, self.class.source_id)
      @r = {}
    end
  end
end
