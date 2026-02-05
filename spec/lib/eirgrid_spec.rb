require 'rails_helper'

RSpec.describe Eirgrid::WindGeneration do
  subject { Eirgrid::WindGeneration }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('eirgrid_wind_generation', &ex) }

    it 'fetches wind generation data for date range and calls Out::Generation.run with parsed data' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source_id|
        expect(points).to be_an(Array)
        expect(points.length).to be > 0

        wind_point = points.find { |p| p[:production_type] == 'wind_onshore' }
        expect(wind_point).to include(
          country: 'IE',
          production_type: 'wind_onshore'
        )
        expect(wind_point[:time]).to be_a(Time)
        expect(wind_point[:value]).to be_a(Numeric)

        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('eirgrid')
      end

      subject.cli(%w[2025-01-15 2025-01-15])
    end
  end
end

RSpec.describe Eirgrid::Price do
  subject { Eirgrid::Price }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('eirgrid_price', &ex) }

    it 'fetches price data for date range and calls Out::Price.run' do
      expect(Out::Price).to receive(:run) do |points, from, to, source_id|
        expect(points).to be_an(Array)
        expect(points.length).to be > 0

        expect(points.first).to include(
          country: 'IE'
        )
        expect(points.first[:value]).to be_a(Numeric)

        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('eirgrid')
      end

      subject.cli(%w[2025-11-25 2025-11-26])
    end
  end
end

RSpec.describe Eirgrid::Load do
  subject { Eirgrid::Load }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('eirgrid_load', &ex) }

    it 'fetches load data for date range and calls Out::Load.run' do
      expect(Out::Load).to receive(:run) do |points, from, to, source_id|
        expect(points).to be_an(Array)
        expect(points.length).to be > 0

        expect(points.first).to include(
          country: 'IE'
        )
        expect(points.first[:value]).to be_a(Numeric)

        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('eirgrid')
      end

      subject.cli(%w[2025-01-15 2025-01-15])
    end
  end
end
