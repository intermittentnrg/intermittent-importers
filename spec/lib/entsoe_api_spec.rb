require 'rails_helper'

RSpec.describe EntsoeApi do
  describe EntsoeApi::Generation do
    subject { EntsoeApi::Generation }
    describe :cli do
      around(:example) { |ex| VCR.use_cassette('entsoe_api_generation_DE_2021-01-01_2021-01-02', &ex) }
      it "calls Out::Generation.run with expected data for single country" do
        expect(Out::Generation).to receive(:run).once do |data, from, to, source_id|
          expect(data.length).to eq(1536)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source_id).to eq('entsoe')
        end
        subject.cli(['2021-01-01', '2021-01-02', 'DE'])
      end
    end
  end

  describe EntsoeApi::Load do
    subject { EntsoeApi::Load }
    describe :cli do
      around(:example) { |ex| VCR.use_cassette('entsoe_api_load_FR_2021-01-01_2021-01-02', &ex) }
      it "calls Out::Load.run with expected data for single country" do
        expect(Out::Load).to receive(:run).once do |data, from, to, source_id|
          expect(data.length).to eq(24)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source_id).to eq('entsoe')
        end
        subject.cli(['2021-01-01', '2021-01-02', 'FR'])
      end
    end
  end

  describe EntsoeApi::Price do
    subject { EntsoeApi::Price }
    describe :cli do
      around(:example) { |ex| VCR.use_cassette('entsoe_api_prices_SE1', &ex) }
      it "calls Out::Price.run with expected data for single country" do
        expect(Out::Price).to receive(:run).once do |data, from, to, source_id|
          expect(data.length).to eq(48)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source_id).to eq('entsoe')
        end
        subject.cli(['2021-01-01', '2021-01-02', 'SE1'])
      end
    end
    describe 'gapfill' do
      around(:example) { |ex| VCR.use_cassette('entsoe_api_prices_gapfill', &ex) }
      it "fills gaps in price data when curveType is A03" do
        expect(Out::Price).to receive(:run).once do |data, from, to, source_id|
          expect(data.length).to eq(24)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source_id).to eq('entsoe')
          # Check that the gap at position 6 was filled
          times = data.map { |p| p[:time] }
          expect(times).to include(Time.parse('2024-12-29 04:00:00 UTC'))
        end
        EntsoeApi::Price.cli(['2024-12-29', '2024-12-29', 'PT'])
      end
    end
  end

  describe EntsoeApi::Transmission do
    subject { EntsoeApi::Transmission }
    describe :cli do
      around(:example) { |ex| VCR.use_cassette('entsoe_api_transmission_SE4_DE-LU_2021-01-01_2021-01-02', &ex) }
      it "calls Out::Transmission.run with expected data for single pair" do
        expect(Out::Transmission).to receive(:run).once do |data, from, to, source_id|
          expect(data.length).to eq(24)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source_id).to eq('entsoe')
        end
        subject.cli(['2021-01-01', '2021-01-02', 'SE4', 'DE-LU'])
      end
    end
  end
end
