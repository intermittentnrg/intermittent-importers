# frozen_string_literal: true

require 'zip'
require 'fastest_csv'

module EntsoeCsv
  class Base
    include SemanticLogger::Loggable

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
      @production_type_cache = {}
      @time_cache = {}
    end

    def add_file(path, name: nil, time: nil, zip: false)
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
      @production_type_cache[s] ||= begin
        pt = s.strip.gsub(/ /, '_').downcase
        PT_MAP[pt] || pt
      end
    end

    TIME_FORMAT = '%Y-%m-%d %H:%M:%S.%L'
    def parse_time(s)
      @time_cache[s] ||= Time.strptime(s, self.class::TIME_FORMAT)
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

    VALIDATION_GEN = {
      all: {
        solar: { max: 100_000_000 },
        hydro_pumped_storage: { min: -100_000_000 },
        hydro_run_of_river_and_poundage: { min: -100_000_000 },
        hydro_water_reservoir: { min: -100_000_000 }
      },
      AT: {
        hydro_pumped_storage: { min: -10_000_000 },
        hydro_run_of_river_and_poundage: { min: -1_000_000 },
        hydro_water_reservoir: { min: -1_000_000 }
      },
      DK: {
        fossil_gas: { max: 2_000_000 },
        fossil_oil: { max: 400_000 },
        fossil_hard_coal: { max: 3_000_000 },
        wind_onshore: { max: 6_000_000 },
        waste: { max: 262_000 }
      },
      FR: { nuclear: { min: 15_000_000 } },
      NO: { wind_onshore: { max: 10_000_000 } },
      RS: {
        hydro_run_of_river_and_poundage: { max: 5_000_000 },
        hydro_pumped_storage: { max: 3_000_000 }
      }
    }.with_indifferent_access

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
      r = Validate.validate_generation(@r.values, self.class::VALIDATION_GEN)
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
      @existing_unit_names = {}
      @existing_unit_production_types = {}
      @unit_names_to_save = {}
      @unit_production_types_to_save = {}

      ::Unit.joins(:area).where(area: { source: self.class.source_id }).pluck(:internal_id,
                                                                              :id).each do |internal_id, id|
        @units[internal_id] = id
      end

      unit_ids = @units.values.uniq
      return if unit_ids.empty?

      ::UnitName.where(unit_id: unit_ids).each { |un| @existing_unit_names["#{un.unit_id}:#{un.name}"] = un.updated_at }
      ::UnitProductionType.includes(:production_type).where(unit_id: unit_ids).each do |upt|
        @existing_unit_production_types["#{upt.unit_id}:#{upt.production_type.name}"] = upt.updated_at
      end
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
      unit_name = row[7]
      # 8:GenerationUnitType
      production_type = parse_production_type(row[8])
      # 9:ActualGenerationOutput[MW]
      # 10:ActualConsumption[MW]
      value = parse_value(row[9], row[10])
      # 11:UpdateTime(UTC)

      unit_id = @units[unit_internal_id]
      unless unit_id
        unit = ::Unit.find_or_create_by!(internal_id: unit_internal_id) do |u|
          u.name = unit_name
          u.production_type_id = ProductionType.where(name: production_type).pluck(:id)
          u.area = ::Area.find_by(
            internal_id: AREA_CODE_OVERRIDE[area_code] || area_code,
            source: self.class.source_id
          )
          raise "Missing area #{area_code} / #{row}" unless u.area
        end
        unit_id = @units[unit_internal_id] = unit.id

        unit.unit_names.each { |un| @existing_unit_names["#{un.unit_id}:#{un.name}"] = un.updated_at }
        unit.unit_production_types.includes(:production_type).each do |upt|
          @existing_unit_production_types["#{upt.unit_id}:#{upt.production_type.name}"] = upt.updated_at
        end
      end

      # Use string keys instead of arrays for faster hash lookups
      name_key = "#{unit_id}:#{unit_name}"
      existing_name_time = @existing_unit_names[name_key]
      pending_name_time = @unit_names_to_save[name_key]
      if (!existing_name_time || time > existing_name_time) && (!pending_name_time || time > pending_name_time)
        @unit_names_to_save[name_key] = time
      end

      pt_key = "#{unit_id}:#{production_type}"
      existing_pt_time = @existing_unit_production_types[pt_key]
      pending_pt_time = @unit_production_types_to_save[pt_key]
      if (!existing_pt_time || time > existing_pt_time) && (!pending_pt_time || time > pending_pt_time)
        @unit_production_types_to_save[pt_key] = time
      end

      k = "#{time}:#{unit_internal_id}"
      if @r[k] && value != @r[k][:value]
        logger.error "duplicate data with different output #{unit_internal_id} #{value} != #{@r[k][:value]}"
      end
      @r[k] = { unit_id:, time:, value: }
    end

    def done!
      persist_unit_tracking
      super
    end

    def persist_unit_tracking
      return if @unit_names_to_save.empty? && @unit_production_types_to_save.empty?

      # Keys are now strings in format "#{unit_id}:#{name}"
      unit_ids = (@unit_names_to_save.keys + @unit_production_types_to_save.keys).map do |k|
        k.split(':').first.to_i
      end.uniq

      if @unit_names_to_save.any?
        ::UnitName.upsert_all(
          @unit_names_to_save.map do |key, updated_at|
            unit_id, name = key.split(':', 2)
            { unit_id: unit_id.to_i, name:, updated_at: }
          end,
          unique_by: %i[unit_id name]
        )
      end

      if @unit_production_types_to_save.any?
        pt_names = @unit_production_types_to_save.keys.map { |k| k.split(':', 2).last }
        pt_ids_by_name = ProductionType.where(name: pt_names).pluck(:name, :id).to_h
        ::UnitProductionType.upsert_all(
          @unit_production_types_to_save.map do |key, updated_at|
            unit_id, pt_name = key.split(':', 2)
            { unit_id: unit_id.to_i, production_type_id: pt_ids_by_name[pt_name], updated_at: }
          end,
          unique_by: %i[unit_id production_type_id]
        )
      end

      return if Rails.env.production?

      unit_ids.each do |unit_id|
        unit = ::Unit.find(unit_id)
        latest_name = ::UnitName.where(unit_id:).order(updated_at: :desc).first
        if latest_name && latest_name.name != unit.name
          logger.info "#{unit.internal_id} Updating name #{unit.name.inspect} -> #{latest_name.name.inspect}"
          unit.update!(name: latest_name.name)
        end

        latest_pt = ::UnitProductionType.where(unit_id:).order(updated_at: :desc).first
        if latest_pt && latest_pt.production_type_id != unit.production_type_id
          logger.info "#{unit.internal_id} Updating production_type #{unit.production_type.name} -> #{latest_pt.production_type.name}"
          unit.update!(production_type_id: latest_pt.production_type_id)
        end
      end
    end

    def flush
      Out::Unit.run(@r.values, @from, @to, self.class.source_id)
      @r = {}
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    VALIDATION_LOAD = {
      all: { min: 1000, max: 600_000_000 },
      BA: { max: 2_800_000 }
    }.with_indifferent_access

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
      r = Validate.validate_load(@r.values, self.class::VALIDATION_LOAD)
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
