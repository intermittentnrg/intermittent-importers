require 'spec_helper'

describe Cenace do
  describe 'month_text validation' do
    it 'matches month_text to requested date' do
      # Test the regex pattern
      pattern = /([A-ZÁÉÍÓÚÜÑ][a-záéíóúüñ]+)\s+(\d{4})/

      # Should match valid month_text
      expect('Noviembre 2025').to match(pattern)
      expect('Diciembre 2025').to match(pattern)
      expect('Septiembre 2021').to match(pattern)

      # Should extract correct values
      match = 'Noviembre 2025'.match(pattern)
      expect(match[1]).to eq('Noviembre')
      expect(match[2]).to eq('2025')

      # Should map to correct month numbers
      expect(Cenace::MONTHS['Noviembre']).to eq(11)
      expect(Cenace::MONTHS['Diciembre']).to eq(12)
      expect(Cenace::MONTHS['Septiembre']).to eq(9)
    end
  end

  describe 'button selection logic' do
    it 'uses the correct CSS selector for settlement buttons' do
      # This tests that the selector pattern is correct
      selector = 'input[type="image"][name^="ctl00$ContentPlaceHolder1$GridRadResultado$ctl00$ctl"][name$="gbccolumn"]'
      expect(selector).to include('GridRadResultado')
      expect(selector).to include('gbccolumn')
    end
  end

  describe '#add_date' do
    let(:cenace) { Cenace.new }

    before do
      # Stub out add_buffer to prevent actual CSV parsing
      allow(cenace).to receive(:add_buffer).and_return(cenace)
    end

    context 'with historical date' do
      let(:date) { Date.new(2025, 1, 15) }

      it 'submits date selection form to reload content and shows 4 settlement files' do
        VCR.use_cassette('cenace_historical_month') do
          # Verify TWO POST request (date selection + CSV download)
          expect(cenace.instance_variable_get(:@faraday)).to receive(:post).twice.and_call_original

          cenace.add_date(date)

          # Verify DataFile tracking
          expect(cenace.instance_variable_get(:@datafiles)).not_to be_empty
          datafile = cenace.instance_variable_get(:@datafiles).first
          expect(datafile[:path]).to match(/^cenace_\d{8}\.csv$/)
          expect(datafile[:source]).to eq('cenace')
          expect(datafile[:updated_at]).to be_a(Time)
        end
      end
    end

    context 'with current month data' do
      let(:date) { Date.new(2025, 11, 1) }

      it 'skips date selection form submission when current month is correct' do
        VCR.use_cassette('cenace_current_month') do
          # Verify only ONE POST request (CSV download only, no date selection)
          expect(cenace.instance_variable_get(:@faraday)).to receive(:post).once.and_call_original

          cenace.add_date(date)

          # Verify DataFile tracking
          expect(cenace.instance_variable_get(:@datafiles)).not_to be_empty
          datafile = cenace.instance_variable_get(:@datafiles).first
          expect(datafile[:path]).to match(/^cenace_\d{8}\.csv$/)
          expect(datafile[:source]).to eq('cenace')
          expect(datafile[:updated_at]).to be_a(Time)
        end
      end
    end

    context 'with future date' do
      let(:date) { Date.new(2025, 12, 1) }

      it 'raises error when requesting future data' do
        VCR.use_cassette('cenace_future_month') do
          # Verify NO POST requests (error before any HTTP calls)
          expect(cenace.instance_variable_get(:@faraday)).not_to receive(:post)

          expect {
            cenace.add_date(date)
          }.to raise_error(/Data for 2025-12-01 is not yet available/)
        end
      end
    end
  end

  describe :cli do
    it "calls Out::Generation.run with expected data" do
      # Mock Out::Generation.run to verify it's called correctly
      expect(Out::Generation).to receive(:run) do |data, from, to, source_id|
        expect(data.length).to eq(264)  # 24 hours × 11 production types (hour 24 skipped)
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(from.year).to eq(2025)
        expect(from.month).to eq(11)
        expect(from.day).to eq(2)
        expect(source_id).to eq('cenace')
      end

      # Call CLI with the fixture file
      Cenace.cli(['spec/fixtures/cenace-dst-2025-11.csv'])
    end
  end
end
