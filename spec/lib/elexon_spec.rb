require 'spec_helper'
require 'timecop'

RSpec.describe Elexon::Generation do
  subject { Elexon::Generation }
  describe :cli do
    it 'processes generation data end-to-end' do
      csv_body = <<-CSV
Dataset,DocumentId,DocumentRevisionNumber,PublishTime,BusinessType,PsrType,Quantity,StartTime,SettlementDate,SettlementPeriod\r
AGPT,NGET-EMFIP-AGPT-06417742,1,2023-01-01T23:59:09Z,Solar generation,Solar,1000.000,2023-01-01T22:30:00Z,2023-01-01,46\r
AGPT,NGET-EMFIP-AGPT-06417742,1,2023-01-01T23:59:09Z,Production,Wind,2000.000,2023-01-01T22:30:00Z,2023-01-01,46\r
CSV

      stub_request(:get, 'https://data.elexon.co.uk/bmrs/api/v1/datasets/AGPT?format=csv&publishDateTimeFrom=2023-01-01%2000:00&publishDateTimeTo=2023-01-02%2000:00').
        to_return(body: csv_body)

      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(2)
        expect(points.first[:country]).to eq('GB_B1620')
        expect(source).to eq('elexon')
      end

      subject.cli(['2023-01-01', '2023-01-02'])
    end
  end
end

RSpec.describe Elexon::Fuelinst do
  subject { Elexon::Fuelinst }
  describe :cli do
    it 'processes fuelinst data end-to-end' do
      csv_body = <<-CSV
Dataset,PublishTime,StartTime,SettlementDate,SettlementPeriod,FuelType,Generation\r
FUELINST,2023-07-19T23:00:00Z,2023-07-19T22:55:00Z,2023-07-19,48,BIOMASS,1902\r
FUELINST,2023-07-19T23:00:00Z,2023-07-19T22:55:00Z,2023-07-19,48,CCGT,13259\r
FUELINST,2023-07-19T23:00:00Z,2023-07-19T22:55:00Z,2023-07-19,48,INTELEC,126\r
FUELINST,2023-07-19T23:00:00Z,2023-07-19T22:55:00Z,2023-07-19,48,INTFR,403\r
CSV

      stub_request(:get, 'https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELINST?format=csv&settlementDateFrom=2023-07-18&settlementDateTo=2023-07-19').
        to_return(body: csv_body)

      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(2)
        expect(points.first[:country]).to eq('GB')
        expect(source).to eq('elexon')
      end

      expect(Out::Transmission).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1)
        expect(points.first[:from_area]).to eq('GB')
        expect(points.first[:to_area]).to eq('FR')
        expect(source).to eq('elexon')
      end

      subject.cli(['2023-07-18', '2023-07-19'])
    end
  end
end

RSpec.describe Elexon::Load do
  subject { Elexon::Load }
  describe :cli do
    it 'processes load data end-to-end' do
      csv_body = <<-CSV
PublishTime,StartTime,SettlementDate,SettlementPeriod,Quantity\r
2023-07-19T01:55:08Z,2023-07-19T00:00:00Z,2023-07-19,3,19999.000\r
2023-07-19T01:25:09Z,2023-07-18T23:30:00Z,2023-07-19,2,20610.000\r
2023-07-19T00:55:08Z,2023-07-18T23:00:00Z,2023-07-19,1,21424.000\r
2023-07-19T00:25:09Z,2023-07-18T22:30:00Z,2023-07-18,48,24137.000\r
CSV

      stub_request(:get, 'https://data.elexon.co.uk/bmrs/api/v1/demand/actual/total?format=csv&from=2023-07-18&to=2023-07-19').
        to_return(body: csv_body)

      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(4)
        expect(points.first[:country]).to eq('GB')
        expect(source).to eq('elexon')
      end

      subject.cli(['2023-07-18', '2023-07-19'])
    end
  end
end

RSpec.describe Elexon::Unit do
  subject { Elexon::Unit }
  let(:body) do
    <<-CSV
Dataset,PsrType,BmUnit,NationalGridBmUnitId,SettlementDate,SettlementPeriod,HalfHourEndTime,Quantity\r
B1610,Generation,E_HYWDW-1,HYWDW-1,2023-09-01,20,09/01/2023 09:00:00,0.074
CSV
  end
  let(:unit_id) { 'HYWDW-1' }

  before do
    stub_request(:get, %r|https://data\.elexon\.co\.uk/bmrs/api/v1/datasets/B1610\?format=csv&settlementDate=2023-09-01&settlementPeriod=\d+|).
      to_return(body:)
  end

  describe :cli do
    context 'with date range and unit' do
      let(:args) { ['2023-09-01', '2023-09-02'] }
      it do
        expect(::GenerationUnit).to receive(:upsert_all).at_least(:once)
        subject.cli(args)
      end
    end
  end

  let(:current_time) { Time.new(2016, 12, 5, 12) }
  xdescribe :refresh_to do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    it do
      expect(subject.refresh_to).to eq Time.new(2016,11,28,12)
    end
  end

  describe :each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    before do
      unit = Unit.find_by!(internal_id: unit_id)
      GenerationUnit.create(unit:, time:, value: 100)
    end

    # The SAA performs the II run 5 Working Days after the actual date
    # so the most recent data shown on this page will be for a date almost a week ago.
    # For example on 05 December 2016 users will be able to access data up to 27 November 2016.
    context "does nothing if data is fresh" do
      let(:time) { Time.new(2026,11,27) }
      it do
        expect(Elexon::Unit).not_to receive(:new)
        expect { |b|
          subject.each(&b)
        }.not_to yield_with_args
      end
    end

    context "skips last 4 business days" do
      let!(:parser) { double('Elexon::Unit') }
      let(:time) { Time.new(2016,11,27) }
      it do
        parser = double('Elexon::Unit')
        (1..50).each do |period|
          expect(Elexon::Unit).to receive(:new).with(Time.new(2016,11,27), period) { parser }
        end
        (1..50).each do |period|
          expect(Elexon::Unit).to receive(:new).with(Time.new(2016,11,28), period) { parser }
        end
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*[parser]*50*2)
      end
    end
  end

  # TODO The units for generation data before the 10th July 2015 were expressed in MWh instead of MW. As a result, generation data published after 9th July was increased by a factor of 2 to account for the unit change from MWh to MW.
end
