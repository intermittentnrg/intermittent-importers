require 'rails_helper'

RSpec.describe NordpoolUmm do
  describe '.cli' do
    around(:example) { |ex| VCR.use_cassette('nordpool_umm_nuclear', &ex) }

    it 'displays nuclear outages for area' do
      output = capture_stdout do
        described_class.cli(%w[--fuel-types nuclear --areas SE3 --event-start-date 2026-02-20 --event-stop-date
                               2026-03-01])
      end

      expect(output).to include('NordPool UMM - Outages')
      expect(output).to include('Fuel types: nuclear')
      expect(output).to include('Areas: SE3')
    end

    it 'displays help' do
      output = capture_stdout do
        described_class.cli(['--help'])
      end

      expect(output).to include('Usage:')
      expect(output).to include('--fuel-types')
      expect(output).to include('--areas')
    end
  end

  describe '.cli with wind' do
    around(:example) { |ex| VCR.use_cassette('nordpool_umm_wind', &ex) }

    it 'displays wind outages' do
      output = capture_stdout do
        described_class.cli(%w[--fuel-types wind --event-start-date 2026-02-20 --event-stop-date 2026-03-01])
      end

      expect(output).to include('Fuel types: wind')
    end
  end

  describe '.cli with transmission' do
    around(:example) { |ex| VCR.use_cassette('nordpool_umm_transmission', &ex) }

    it 'displays transmission outages for nordic region' do
      output = capture_stdout do
        described_class.cli(%w[--message-types TransmissionUnavailability --areas nordic --event-start-date 2026-02-01
                               --event-stop-date 2026-02-28])
      end

      expect(output).to include('Message types: TransmissionUnavailability')
      expect(output).to include('Areas: nordic')
      expect(output).to include('unit(s)')
    end
  end

  describe '.parse_args' do
    it 'parses fuel types' do
      params = described_class.parse_args(%w[--fuel-types nuclear,wind --event-start-date 2026-02-01 --event-stop-date
                                             2026-03-01])

      expect(params[:fuel_types]).to contain_exactly(14, 18, 19)
      expect(params[:fuel_types_raw]).to eq('nuclear,wind')
    end

    it 'parses areas with region preset' do
      params = described_class.parse_args(%w[--areas nordic --event-start-date 2026-02-01 --event-stop-date 2026-03-01])

      expect(params[:areas]).to be_an(Array)
      expect(params[:areas].length).to eq(12)
      expect(params[:areas]).to include('10Y1001A1001A46L')
    end

    it 'parses message types' do
      params = described_class.parse_args(%w[--message-types TransmissionUnavailability --event-start-date 2026-02-01
                                             --event-stop-date 2026-03-01])

      expect(params[:message_types]).to eq([3])
      expect(params[:message_types_raw]).to eq('TransmissionUnavailability')
    end

    it 'parses dates' do
      params = described_class.parse_args(%w[--event-start-date 2026-02-01 --event-stop-date 2026-03-01])

      expect(params[:event_start_date]).to be_a(Time)
      expect(params[:event_stop_date]).to be_a(Time)
    end

    it 'rejects invalid parameters' do
      expect do
        described_class.parse_args(%w[--invalid-param value])
      end.to raise_error(/Unknown parameter/)
    end
  end

  describe '.resolve_areas' do
    it 'returns EIC codes for nordic region preset' do
      eics = described_class.resolve_areas('nordic')

      expect(eics).to be_an(Array)
      expect(eics.length).to eq(12)
      expect(eics).to include('10Y1001A1001A46L')
      expect(eics).to include('10YFI-1--------U')
    end

    it 'returns EIC codes for area prefix match' do
      eics = described_class.resolve_areas('SE')

      expect(eics).to be_an(Array)
      expect(eics.length).to eq(4)
      expect(eics).to include('10Y1001A1001A44P')
      expect(eics).to include('10Y1001A1001A47J')
    end

    it 'returns EIC code directly if already EIC format' do
      eics = described_class.resolve_areas('10Y1001A1001A46L')

      expect(eics).to eq(['10Y1001A1001A46L'])
    end
  end

  describe '.resolve_units' do
    it 'returns EIC code for unit name match' do
      units = described_class.resolve_units('Forsmark')

      expect(units).to be_an(Array)
      expect(units.first).to match(/\A\d{2}[A-Z0-9]{14}\z/)
    end

    it 'returns EIC code directly if already EIC format' do
      units = described_class.resolve_units('46WGU0000000009X')

      expect(units).to eq(['46WGU0000000009X'])
    end
  end

  describe '#stations' do
    it 'returns stations array with name and code' do
      stations = described_class.new.stations

      expect(stations).to be_an(Array)
      expect(stations).not_to be_empty

      station = stations.first
      expect(station[:name]).to be_a(String)
      expect(station[:code]).to be_a(String)
    end
  end

  def capture_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end
end
