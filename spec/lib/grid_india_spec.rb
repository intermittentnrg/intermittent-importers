require 'rails_helper'
require 'roo'
require 'roo-xls'

RSpec.describe GridIndia do
  let(:test_file) { 'spec/fixtures/grid_india_2025-12-01.xls' }
  let(:importer) { described_class.new }

  before do
    # Skip test if file doesn't exist
    skip "Test file #{test_file} not found" unless File.exist?(test_file)
  end

  describe '#process_file' do
    it 'parses the Excel file and extracts generation data' do
      importer.add_file(test_file)

      gen_data = importer.instance_variable_get(:@r_gen)
      load_data = importer.instance_variable_get(:@r_load)

      # Should have generation data
      expect(gen_data).not_to be_empty
      expect(gen_data.length).to eq(672) # 96 time slots × 7 production types

      # Should have load data
      expect(load_data).not_to be_empty
      expect(load_data.length).to eq(96) # 96 time slots

      # Check first generation point
      first_point = gen_data.first
      expect(first_point).to have_key(:time)
      expect(first_point).to have_key(:country)
      expect(first_point).to have_key(:production_type)
      expect(first_point).to have_key(:value)
      expect(first_point[:country]).to eq('IN')
      expect(first_point[:value]).to be_a(Numeric)
    end

    it 'maps production types correctly' do
      importer.add_file(test_file)
      gen_data = importer.instance_variable_get(:@r_gen)

      production_types = gen_data.map { |p| p[:production_type] }.uniq
      expect(production_types).to include(:nuclear, :wind, :solar, :hydro, :fossil_gas, :fossil_coal, :other_renewable)
    end

    it 'converts values from MW to kW' do
      importer.add_file(test_file)
      gen_data = importer.instance_variable_get(:@r_gen)

      # Nuclear should be around 4858 MW = 4,858,000 kW (not 142,494,000)
      nuclear_points = gen_data.select { |p| p[:production_type] == :nuclear }
      first_nuclear = nuclear_points.first

      expect(first_nuclear[:value]).to be_within(10_000_000).of(5_000_000)
      expect(first_nuclear[:value]).to be < 10_000_000 # Should not be demand value
    end

    it 'has no gaps in generation data' do
      importer.add_file(test_file)
      gen_data = importer.instance_variable_get(:@r_gen)

      by_type = gen_data.group_by { |p| p[:production_type] }
      expected_count = 96 # 15-minute intervals in a day

      by_type.each do |production_type, points|
        expect(points.length).to eq(expected_count),
                                 "Production type #{production_type} has #{points.length} points, expected #{expected_count}"
      end
    end

    it 'has no gaps in load data' do
      importer.add_file(test_file)
      load_data = importer.instance_variable_get(:@r_load)

      expect(load_data.length).to eq(96)
    end

    it 'has nuclear values within India capacity' do
      importer.add_file(test_file)
      gen_data = importer.instance_variable_get(:@r_gen)

      # India has 7.49 GW nuclear capacity
      # Values are in kW, so max should be < 7,490,000 kW
      max_nuclear_capacity_kw = 7_490_000

      nuclear_points = gen_data.select { |p| p[:production_type] == :nuclear }
      nuclear_points.each do |point|
        expect(point[:value]).to be <= max_nuclear_capacity_kw,
                                 "Nuclear value #{point[:value]} kW exceeds India's capacity of #{max_nuclear_capacity_kw} kW"
      end
    end

    it 'parses time correctly in UTC' do
      importer.add_file(test_file)
      gen_data = importer.instance_variable_get(:@r_gen)
      importer.instance_variable_get(:@r_load)

      # First time should be 00:00 IST = 18:30 UTC (previous day)
      first_time = gen_data.map { |p| p[:time] }.min
      expect(first_time.hour).to eq(18)
      expect(first_time.min).to eq(30)

      # Last time should be 23:45 IST = 18:15 UTC
      last_time = gen_data.map { |p| p[:time] }.max
      expect(last_time.hour).to eq(18)
      expect(last_time.min).to eq(15)
    end
  end

  describe '#done!' do
    it 'calls Out::Generation and Out::Load with correct data' do
      importer.add_file(test_file)

      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points).to be_an(Array)
        expect(points.length).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('grid-india')
      end

      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points).to be_an(Array)
        expect(points.length).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('grid-india')
      end

      importer.done!
    end
  end
end
