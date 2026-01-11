require 'rails_helper'

RSpec.describe Kpx::Generation do
  subject { Kpx::Generation }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('kpx_generation', &ex) }

    it "fetches real-time data and calls Out::Generation.run with parsed generation data" do
      expect(Out::Generation).to receive(:run) do |points, from, to, source_id|
        expect(points).to be_an(Array)
        expect(points.length).to eq(153)

        nuclear_point = points.find { |p| p[:production_type] == :nuclear }
        expect(nuclear_point).to include(
          country: 'KR',
          production_type: :nuclear
        )
        expect(nuclear_point[:time]).to be_a(Time)
        expect(nuclear_point[:value]).to be_a(Numeric)

        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('kpx')
      end

      subject.cli([])
    end
  end
end

RSpec.describe Kpx::GenerationHistory do
  subject { Kpx::GenerationHistory }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('kpx_generation_history', &ex) }

    it "fetches historical data for date range and calls Out::Generation.run" do
      expect(Out::Generation).to receive(:run) do |points, from, to, source_id|
        expect(points).to be_an(Array)
        expect(points.length).to eq(2592)

        nuclear_points = points.select { |p| p[:production_type] == :nuclear }
        expect(nuclear_points.length).to eq(288)

        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('kpx')
      end

      subject.cli(['2025-01-05'])
    end
  end
end

RSpec.describe Kpx::Price do
  subject { Kpx::Price }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('kpx_price', &ex) }

    it "fetches price data and calls Out::Price.run" do
      expect(Out::Price).to receive(:run) do |points, from, to, source_id|
        expect(points).to be_an(Array)
        expect(points.length).to be > 0

        # Check that price values are in Won/MWh (multiplied by 1000 from Won/kWh)
        expect(points.first[:value]).to be > 1000

        expect(points.first).to include(
          country: 'KR'
        )

        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('kpx')
      end

      subject.cli([])
    end
  end
end
