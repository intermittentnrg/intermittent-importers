# frozen_string_literal: true

require 'faraday'
require 'json'

module Nspower
  class Base
    TZ = TZInfo::Timezone.get('America/Halifax')

    def self.source_id
      'nspower'
    end
  end

  class Combined < Base
    include SemanticLogger::Loggable

    URL_LOAD = 'https://www.nspower.ca/library/CurrentLoad/CurrentLoad.json'
    URL_MIX = 'https://www.nspower.ca/library/CurrentLoad/CurrentMix.json'

    GEN_MAPPINGS = {
      'Solid Fuel' => :coal,
      'HFO/Natural Gas' => :gas,
      'Biomass' => :biomass,
      'Hydro' => :hydro,
      'Wind' => :wind,
      "CT's" => :oil,
      "LM 6000's" => :gas
    }.freeze

    CAPACITY_LIMITS = {
      biomass: 100,
      coal: 1300,
      gas: 700,
      hydro: 600,
      oil: 300,
      wind: 700
    }.freeze

    def self.cli(args)
      raise 'No arguments allowed' if args.any?

      new.add.done!
    end

    def initialize
      @r_gen = []
      @r_load = []
      @from = nil
      @to = nil
      @conn = Faraday.new
    end

    def add
      # Fetch load data (skip first element as it's always 0)
      load_response = logger.benchmark_info(URL_LOAD) do
        @conn.get(URL_LOAD)
      end
      load_data = JSON.parse(load_response.body)[1..]

      # Fetch generation mix data (skip first element)
      mix_response = logger.benchmark_info(URL_MIX) do
        @conn.get(URL_MIX)
      end
      mix_data = JSON.parse(mix_response.body)[1..]

      # Process load data
      loads = {}
      load_data.each do |row|
        time = parse_timestamp(row['datetime'])
        value = row['Base Load']

        # Track time range
        @from = time if @from.nil? || time < @from
        @to = time if @to.nil? || time > @to

        # Store load data
        @r_load << {
          time: time,
          country: 'CA-NS',
          value: value
        }

        # Store in lookup table for generation calculation
        loads[time] = value
      end

      # Process generation mix data
      mix_data.each do |mix_entry|
        time = parse_timestamp(mix_entry['datetime'])
        load = loads[time]

        # Skip if we don't have load data for this timestamp or load is invalid
        next unless load&.positive?

        # Track time range
        @from = time if @from.nil? || time < @from
        @to = time if @to.nil? || time > @to

        # Process each generation type
        mix_entry.reject { |k, _| %w[datetime Imports].include?(k) }.each do |fuel_type, percentage|
          next if percentage.nil? || percentage.zero?

          # Map fuel type to standard production type
          production_type = GEN_MAPPINGS[fuel_type]
          next unless production_type

          # Calculate absolute value in MW
          value = load * percentage / 100.0

          # Apply capacity limits check (similar to electricityMaps)
          limit = CAPACITY_LIMITS[production_type]
          if limit && value > limit
            logger.warn "Discarding datapoint at #{time} because #{production_type} production (#{value} MW) exceeds capacity limit (#{limit} MW)"
            next
          end

          # Store generation data
          @r_gen << {
            time: time,
            country: 'CA-NS',
            production_type: production_type,
            value: value
          }
        end
      end

      self
    end

    def done!
      Out::Load.run(@r_load, @from, @to, self.class.source_id)
      Out::Generation.run(@r_gen, @from, @to, self.class.source_id)
    end

    private

    def parse_timestamp(timestamp_str)
      # Convert timestamp string like "/Date(1493924400000)/" to Time in UTC
      Time.at(timestamp_str[6..-5].to_i).utc
    end
  end
end
