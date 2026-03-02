require 'rails_helper'
require 'zlib'

RSpec.describe Out::Unit do
  describe '.filter_unchanged_units' do
    let(:from) { Date.parse('2025-01-01') }
    let(:to) { Date.parse('2025-01-02') }
    let(:area) { Area.find_by!(source: 'entsoe', code: 'AT') }
    let(:production_type) { ProductionType.find_by!(name: 'hydro_pumped_storage') }

    describe 'source filtering' do
      it 'returns all data for non-entsoe sources' do
        data = [{ unit_id: 1, time: Time.now, value: 100 }]
        result = Out::Unit.filter_unchanged_units(data, 'other', from, to)
        expect(result).to eq(data)
      end

      it 'returns all data for non-entsoe sources (elexon)' do
        data = [{ unit_id: 1, time: Time.now, value: 100 }]
        result = Out::Unit.filter_unchanged_units(data, 'elexon', from, to)
        expect(result).to eq(data)
      end

      it 'returns data when from date is nil' do
        data = [{ unit_id: 1, time: Time.now, value: 100 }]
        result = Out::Unit.filter_unchanged_units(data, 'entsoe', nil, to)
        expect(result).to eq(data)
      end

      it 'returns data when to date is nil' do
        data = [{ unit_id: 1, time: Time.now, value: 100 }]
        result = Out::Unit.filter_unchanged_units(data, 'entsoe', from, nil)
        expect(result).to eq(data)
      end

      it 'returns empty array when data is empty' do
        result = Out::Unit.filter_unchanged_units([], 'entsoe', from, to)
        expect(result).to eq([])
      end
    end

    describe 'hash comparison with database' do
      let!(:unit1) do
        Unit.create!(area:, production_type:, internal_id: 'TEST-UNIT-1', name: 'Test Unit 1')
      end
      let!(:unit2) do
        Unit.create!(area:, production_type:, internal_id: 'TEST-UNIT-2', name: 'Test Unit 2')
      end
      let(:time1) { Time.parse('2025-01-01 00:00:00 UTC') }
      let(:time2) { Time.parse('2025-01-01 01:00:00 UTC') }
      let(:time3) { Time.parse('2025-01-01 02:00:00 UTC') }

      it 'Ruby and PostgreSQL hash formats match' do
        # Insert test data
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)

        # Get PostgreSQL computed hash (using XOR of CRC32s)
        pg_result = ActiveRecord::Base.connection.execute(<<~SQL)
          SELECT unit_id, bit_xor(crc32((extract(epoch from time)::text || ':' || value::text)::bytea)) as hash
          FROM generation_unit
          WHERE unit_id = #{unit1.id}
          GROUP BY unit_id
        SQL
        pg_hash = pg_result.first['hash']

        # Compute Ruby hash
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 }
        ]
        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)

        # If hashes match, result should be empty (all data filtered out)
        expect(result).to eq([]), "Ruby/PostgreSQL hash mismatch detected - PG: #{pg_hash}, data not filtered"
      end

      def compute_hash(rows)
        rows.map do |r|
          Zlib.crc32(format('%.6f:%d', r[:time].to_f, r[:value].to_i))
        end.reduce(0) { |acc, crc| acc ^ crc }
      end

      it 'returns empty array when all hashes match (unchanged data)' do
        # Insert existing data into DB
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)

        # Create identical incoming data
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq([])
      end

      it 'returns all data when no matching data exists in DB' do
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq(incoming_data)
      end

      it 'returns only changed unit data when one unit matches and another differs' do
        # Insert data for unit1 only
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)

        # Incoming data for both units - unit1 matches, unit2 is new
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 },
          { unit_id: unit2.id, time: time1, value: 300.0 },
          { unit_id: unit2.id, time: time2, value: 400.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result.length).to eq(2)
        expect(result).to all(include(unit_id: unit2.id))
      end

      it 'returns data when value differs for same time' do
        # Insert existing data
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)

        # Incoming data with different value
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 999.0 } # Changed value
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq(incoming_data)
      end

      it 'returns data when time differs (additional row)' do
        # Insert existing data with 2 rows
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)

        # Incoming data with 3 rows (additional time)
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 },
          { unit_id: unit1.id, time: time3, value: 300.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq(incoming_data)
      end

      it 'returns data when time differs (missing row)' do
        # Insert existing data with 3 rows
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)
        GenerationUnit.create!(unit: unit1, time: time3, value: 300)

        # Incoming data with only 2 rows
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq(incoming_data)
      end

      it 'handles float to integer conversion correctly for hash calculation' do
        GenerationUnit.create!(unit: unit1, time: time1, value: 100)
        GenerationUnit.create!(unit: unit1, time: time2, value: 200)

        # Incoming data with float values (should convert to int for comparison)
        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 },
          { unit_id: unit1.id, time: time2, value: 200.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq([])
      end

      it 'handles data outside the time range correctly' do
        outside_time = Time.parse('2024-12-01 00:00:00 UTC')
        GenerationUnit.create!(unit: unit1, time: outside_time, value: 100)

        incoming_data = [
          { unit_id: unit1.id, time: time1, value: 100.0 }
        ]

        result = Out::Unit.filter_unchanged_units(incoming_data, 'entsoe', from, to)
        expect(result).to eq(incoming_data)
      end
    end
  end

  describe '.run integration' do
    let(:from) { Date.parse('2025-01-01') }
    let(:to) { Date.parse('2025-01-02') }
    let(:area) { Area.find_by!(source: 'entsoe', code: 'AT') }
    let(:production_type) { ProductionType.find_by!(name: 'hydro_pumped_storage') }
    let!(:unit) do
      Unit.create!(area:, production_type:, internal_id: 'TEST-RUN-UNIT', name: 'Test Run Unit')
    end
    let(:time) { Time.parse('2025-01-01 00:00:00 UTC') }

    before do
      # Reset cache before each test
      Out::BaseUnit.class_variable_set(:@@units, {})
    end

    it 'filters unchanged data when hashes match' do
      # Insert data that will match exactly
      GenerationUnit.create!(unit:, time:, value: 500)

      incoming_data = [
        { country: 'AT', unit: 'TEST-RUN-UNIT', production_type: :hydro_pumped_storage, time:, value: 500.0 }
      ]

      Out::Unit.run(incoming_data, from, to, 'entsoe')
      # Verify no change
      expect(GenerationUnit.find_by(unit:, time:)&.value).to eq(500)
    end

    it 'processes changed data when hashes differ' do
      # Insert data that differs from incoming
      GenerationUnit.create!(unit:, time:, value: 500)

      incoming_data = [
        { country: 'AT', unit: 'TEST-RUN-UNIT', production_type: :hydro_pumped_storage, time:, value: 600.0 }
      ]

      Out::Unit.run(incoming_data, from, to, 'entsoe')
      # Verify the value was updated
      expect(GenerationUnit.find_by(unit:, time:)&.value).to eq(600)
    end
  end

  describe 'crc32 hash calculation' do
    it 'produces consistent hashes for identical data' do
      time1 = Time.parse('2025-01-01 00:00:00 UTC')
      time2 = Time.parse('2025-01-01 01:00:00 UTC')

      data1 = [
        { unit_id: 1, time: time1, value: 100 },
        { unit_id: 1, time: time2, value: 200 }
      ]

      data2 = [
        { unit_id: 1, time: time1, value: 100 },
        { unit_id: 1, time: time2, value: 200 }
      ]

      hash1 = data1.map do |r|
        Zlib.crc32(format('%.6f:%d', r[:time].to_f, r[:value]))
      end.reduce(0) { |acc, crc| acc ^ crc }

      hash2 = data2.map do |r|
        Zlib.crc32(format('%.6f:%d', r[:time].to_f, r[:value]))
      end.reduce(0) { |acc, crc| acc ^ crc }

      expect(hash1).to eq(hash2)
    end

    it 'produces different hashes for different values' do
      time1 = Time.parse('2025-01-01 00:00:00 UTC')
      time2 = Time.parse('2025-01-01 01:00:00 UTC')

      data1 = [
        { unit_id: 1, time: time1, value: 100 },
        { unit_id: 1, time: time2, value: 200 }
      ]

      data2 = [
        { unit_id: 1, time: time1, value: 100 },
        { unit_id: 1, time: time2, value: 999 } # Different value
      ]

      hash1 = data1.map do |r|
        Zlib.crc32(format('%.6f:%d', r[:time].to_f, r[:value]))
      end.reduce(0) { |acc, crc| acc ^ crc }

      hash2 = data2.map do |r|
        Zlib.crc32(format('%.6f:%d', r[:time].to_f, r[:value]))
      end.reduce(0) { |acc, crc| acc ^ crc }

      expect(hash1).not_to eq(hash2)
    end
  end
end

RSpec.describe Out::UnitCapacity do
  it 'deduplicates capacity data' do
    guc = double('guc')
    expect(GenerationUnitCapacity).to receive(:where) { guc }
    expect(guc).to receive(:pluck) { guc }
    expect(guc).to receive(:first) { 400_000 }

    data = [
      { unit_id: 544, time: Time.parse('2024-07-01 00:00:00'), value: 400_000 },
      { unit_id: 544, time: Time.parse('2024-07-02 00:00:00'), value: 400_000 },
      { unit_id: 544, time: Time.parse('2024-07-01 02:00:00'), value: 4_000_000 }
    ]
    expect(GenerationUnitCapacity).to receive(:upsert_all).with([data.last])
    Out::UnitCapacity.run(data, nil, nil, 'entsoe')
  end
end

RSpec.describe Out::Transmission do
  describe 'creates AreasAreas mapping when missing' do
    let(:from) { Time.parse '2024-01-01 00:00' }
    let(:to) { Time.parse '2024-01-01 02:00' }
    let(:from_area) { Area.where(source: 'entsoe', code: 'ES').first }
    let(:to_area) { Area.where(source: 'entsoe', code: 'FI').first }
    let(:from_area_id) { from_area.id }
    let(:to_area_id) { to_area.id }
    let(:source_id) { 'entsoe' }

    it 'creates AreasArea mapping' do
      expect(AreasArea.where(from_area:, to_area:).count).to equal 0
      data = [
        {
          from_area_id:,
          to_area_id:,
          time: from,
          value: 1000
        }
      ]
      Out::Transmission.run(data, from, to, source_id)
      expect(AreasArea.where(from_area:, to_area:).count).to equal 1
    end
  end
end
