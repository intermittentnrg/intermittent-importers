# frozen_string_literal: true

require 'time'
require 'chronic'
require 'fileutils'
require 'faraday'
require 'fast_jsonparser'

class NordpoolUmm
  URL = 'https://ummapi.nordpoolgroup.com/messages'
  STATIONS_URL = 'https://ummapi.nordpoolgroup.com/infrastructure/stations'
  CACHE_PATH = 'data/nordpool-umm/stations.json'

  FUEL_TYPES = {
    1 => 'biomass', 2 => 'fossil_brown_coal', 3 => 'fossil_coal_derived_gas',
    4 => 'fossil_gas', 5 => 'fossil_hard_coal', 6 => 'fossil_oil',
    7 => 'fossil_oil_shale', 8 => 'fossil_peat', 9 => 'geothermal',
    10 => 'hydro_pumped_storage', 11 => 'hydro_run_of_river', 12 => 'hydro',
    13 => 'marine', 14 => 'nuclear', 15 => 'other_renewable', 16 => 'solar',
    17 => 'waste', 18 => 'wind_offshore', 19 => 'wind_onshore', 100 => 'other'
  }.freeze

  FUEL_CODES = FUEL_TYPES.invert.merge(
    'wind' => [18, 19]
  ).freeze

  AREAS = {
    'UK' => '10Y1001A1001A57G', '50Hz' => '10YDE-VE-------2',
    'TBW' => '10YDE-ENBW-----N', 'AMP' => '10YDE-RWENET---I',
    'TTG' => '10YDE-EON------1', 'AT' => '10YAT-APG------L',
    'NL' => '10YNL----------L', 'FR' => '10YFR-RTE------C',
    'NO1' => '10YNO-1--------2', 'NO2' => '10YNO-2--------T',
    'NO3' => '10YNO-3--------J', 'NO4' => '10YNO-4--------9',
    'NO5' => '10Y1001A1001A48H', 'FI' => '10YFI-1--------U',
    'BE' => '10YBE----------2', 'DK1' => '10YDK-1--------W',
    'DK2' => '10YDK-2--------M', 'SE1' => '10Y1001A1001A44P',
    'SE2' => '10Y1001A1001A45N', 'SE3' => '10Y1001A1001A46L',
    'SE4' => '10Y1001A1001A47J', 'EE' => '10Y1001A1001A39I',
    'LV' => '10YLV-1001A00074', 'LT' => '10YLT-1001A0008Q',
    'PL' => '10YPL-AREA-----S'
  }.freeze

  REGIONS = {
    'NORDIC' => %w[SE1 SE2 SE3 SE4 FI DK1 DK2 NO1 NO2 NO3 NO4 NO5]
  }.freeze

  MESSAGE_TYPES = {
    'ProductionUnavailability' => 1,
    'LoadReductionAvailability' => 2,
    'TransmissionUnavailability' => 3,
    'OtherMarketInformation' => 5
  }.freeze

  VALID_PARAMS = %w[
    messageTypes status unavailabilityType publicationStartDate publicationStopDate
    eventStartDate eventStopDate areas fuelTypes marketParticipants units connections
    companies searchText skip limit order orderDirection includeOutdated
  ].freeze

  EIC_PATTERN = /\A\d{2}[A-Z0-9]{14}\z/

  def self.cli(args)
    if args.include?('--help') || args.include?('-h')
      puts <<~HELP
        NordPool UMM - Query outages

        Usage:
          NordpoolUmm --fuel-types <types> --areas <areas> --event-start-date <date> --event-stop-date <date> [options]

        Options:
          --fuel-types <types>          Fuel types: nuclear, wind, solar, hydro, etc. (comma-separated)
          --areas <areas>               Areas: SE1-SE4, FI, DK1-DK2, NO1-NO5, or 'nordic' preset (comma-separated)
          --units <names_or_eics>       Units by name or EIC code (comma-separated)
          --message-types <types>       Message types: ProductionUnavailability, TransmissionUnavailability
          --event-start-date <date>     Start date (parsed by Chronic)
          --event-stop-date <date>      Stop date (parsed by Chronic)
          --limit <num>                 Max results (default: 2000)

        Area presets:
          nordic                        SE1-SE4, FI, DK1-DK2, NO1-NO5

        Examples:
          NordpoolUmm --fuel-types nuclear --areas nordic --event-start-date 2026-02-01 --event-stop-date 2026-03-01
          NordpoolUmm --fuel-types wind --areas SE3,FI --event-start-date 2026-02-01 --event-stop-date 2026-03-01
          NordpoolUmm --message-types TransmissionUnavailability --areas nordic --event-start-date 2026-02-01 --event-stop-date 2026-02-28
          NordpoolUmm --fuel-types nuclear --units Björnberget --event-start-date 2026-02-01 --event-stop-date 2026-03-01
      HELP
      return
    end

    params = parse_args(args)

    puts 'NordPool UMM - Outages'
    puts '=' * 80
    puts "Fuel types: #{params[:fuel_types_raw]}" if params[:fuel_types_raw]
    puts "Message types: #{params[:message_types_raw]}" if params[:message_types_raw]
    puts "Areas: #{params[:areas_raw]}" if params[:areas_raw]
    puts "Units: #{params[:units_raw]}" if params[:units_raw]
    if params[:event_start_date] && params[:event_stop_date]
      puts "Period: #{params[:event_start_date].strftime('%Y-%m-%d')} to #{params[:event_stop_date].strftime('%Y-%m-%d')}"
    end
    puts ''

    outages = new.messages(**params.reject { |k, _| k.to_s.end_with?('_raw') })

    display_outages(outages, transmission: params[:message_types]&.include?(3))
  end

  def self.parse_args(args)
    params = {}

    args.each_slice(2) do |key, value|
      raise "Invalid parameter: #{key}" unless key.start_with?('--')

      param = key.sub(/^--/, '').gsub(/-([a-z])/) { ::Regexp.last_match(1).upcase }
      raise "Unknown parameter: #{key}" unless VALID_PARAMS.include?(param)

      result = transform_param(param, value)
      params.merge!(result.is_a?(Hash) ? result : { param => result })
    end

    params[:limit] ||= 2000
    params
  end

  def self.transform_param(param, value)
    case param
    when 'fuelTypes'
      { fuel_types: value.split(',').flat_map { |t| FUEL_CODES[t.strip.downcase] || raise("Unknown fuel type: #{t}") },
        fuel_types_raw: value }
    when 'areas'
      { areas: resolve_areas(value), areas_raw: value }
    when 'units'
      { units: resolve_units(value), units_raw: value }
    when 'messageTypes'
      { message_types: value.split(',').map { |t| MESSAGE_TYPES[t.strip] || t.strip.to_i },
        message_types_raw: value }
    when 'eventStartDate'
      parsed = Chronic.parse(value)&.utc
      raise "Cannot parse: #{value}" unless parsed

      { event_start_date: parsed }
    when 'eventStopDate'
      parsed = Chronic.parse(value)&.utc
      raise "Cannot parse: #{value}" unless parsed

      { event_stop_date: parsed }
    when 'limit'
      { limit: value.to_i }
    else
      { param => value }
    end
  end

  def self.resolve_areas(str)
    str.split(',').flat_map do |area|
      area = area.strip
      area_up = area.upcase

      if REGIONS.key?(area_up)
        REGIONS[area_up].map { |code| AREAS[code] }
      elsif AREAS.key?(area_up)
        [AREAS[area_up]]
      elsif area.match?(EIC_PATTERN)
        [area]
      else
        AREAS.select { |code, _| code.start_with?(area_up) }.values
      end
    end
  end

  def self.resolve_units(str)
    instance = new
    str.split(',').map do |unit|
      unit = unit.strip
      next unit if unit.match?(EIC_PATTERN)

      match = instance.stations.find { |s| s[:name]&.downcase&.include?(unit.downcase) }
      match&.dig(:code) || unit
    end
  end

  def self.display_outages(data, transmission: false)
    items = data[:items] || []

    if items.empty?
      puts 'No outages found'
      return
    end

    result = []
    items.each do |item|
      units_key = transmission ? :transmissionUnits : :productionUnits
      (item[units_key] || item[:generationUnits] || []).each do |u|
        (u[:timePeriods] || []).each do |period|
          result << {
            asset_name: u[:name],
            asset_eic: u[:eic] || u[:name],
            fuel_type: FUEL_TYPES[u[:fuelType]] || 'transmission',
            area_name: transmission ? "#{u[:outAreaName]} → #{u[:inAreaName]}" : u[:areaName],
            installed_capacity: u[:installedCapacity],
            start_time: Time.parse(period[:eventStart]).utc,
            end_time: Time.parse(period[:eventStop]).utc,
            unavailable_capacity: period[:unavailableCapacity].to_f,
            available_capacity: period[:availableCapacity].to_f,
            reason: item[:unavailabilityReason],
            remarks: item[:remarks]
          }
        end
      end
    end

    result.sort_by! { |o| o[:start_time] }

    by_unit = result.group_by { |o| o[:asset_name] }

    puts "#{by_unit.length} unit(s), #{result.length} outage period(s):"
    puts ''

    by_unit.each do |name, periods|
      installed = periods.first[:installed_capacity]
      area_name = periods.first[:area_name]

      puts '-' * 70
      puts "#{name} (#{area_name}) - #{installed} MW installed"
      puts ''

      last_message = nil
      periods.each do |p|
        available = p[:installed_capacity] - p[:unavailable_capacity]
        pct_available = installed.positive? ? (available / installed * 100).round(0) : 0

        message_parts = []
        message_parts << p[:reason] if p[:reason]
        message_parts << p[:remarks] if p[:remarks] && p[:remarks] != p[:reason]
        current_message = message_parts.join(' | ')

        puts "  #{p[:start_time].strftime('%m-%d %H:%M')} -> #{p[:end_time].strftime('%m-%d %H:%M')} | #{available.to_i}/#{installed.to_i} MW (#{pct_available}%) - #{p[:unavailable_capacity].to_i} MW unavailable"
        next unless !current_message.empty? && current_message != last_message

        puts "    #{current_message}"
        puts ''
        last_message = current_message
      end
      puts ''
    end
  end

  def self.messages(params)
    new.messages(params)
  end

  def messages(params)
    api_params = params.transform_values do |v|
      v.is_a?(Array) ? v : v
    end

    res = connection.get(URL) do |req|
      req.params = api_params
    end
    FastJsonparser.parse(res.body)
  end

  def connection
    @connection ||= Faraday.new do |f|
      f.response :raise_error
    end
  end

  def messages(fuel_types: nil, areas: nil, units: nil, message_types: nil, event_start_date: nil,
               event_stop_date: nil, limit: 2000, **)
    params = { status: 'Active', limit: limit }
    params[:fuelTypes] = Array(fuel_types) if fuel_types
    params[:areas] = Array(areas) if areas && !areas.empty?
    params[:units] = Array(units) if units && !units.empty?
    params[:messageTypes] = Array(message_types) if message_types
    params[:eventStartDate] = event_start_date.strftime('%Y-%m-%dT%H:%M:%SZ') if event_start_date
    params[:eventStopDate] = event_stop_date.strftime('%Y-%m-%dT%H:%M:%SZ') if event_stop_date

    res = connection.get(URL) do |req|
      req.params = params
    end
    FastJsonparser.parse(res.body)
  end

  def stations
    return @stations if @stations

    if File.exist?(CACHE_PATH)
      @stations = FastJsonparser.parse(File.read(CACHE_PATH))
    else
      res = connection.get(STATIONS_URL)
      @stations = FastJsonparser.parse(res.body)
      FileUtils.mkdir_p(File.dirname(CACHE_PATH))
      File.write(CACHE_PATH, res.body)
    end

    @stations
  end
end
