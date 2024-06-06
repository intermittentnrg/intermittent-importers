require 'spec_helper'
require 'timecop'

RSpec.describe Elexon::Generation do
  subject { Elexon::Generation }
  describe :cli do
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      areas = Area.find_by! internal_id: 'GB', source: 'elexon'
      production_type = ProductionType.find_by! name: 'wind'
      apt = areas.areas_production_type.find_by!(production_type:)
      apt.generation.create(time: datapoint_time, value: 1000)
    end

    it do
      parser = double('Elexon::Generation')
      # FIXME don't call for tomorrow
      expect(parser).to receive(:process).twice
      expect(subject).to receive(:new).twice { parser }
      subject.parsers_each &:process
    end
  end
end

RSpec.describe Elexon::Fuelinst do
  subject { Elexon::Fuelinst }
  describe :cli do
    let(:body) do
      <<-CSV
FUELINST,2023-01-02T00:30:00Z,2023-01-02T00:25:00Z,2023-01-02,1,NUCLEAR,5723
      CSV
    end
    context 'single date as argument' do
      it do
        stub_request(:get, 'https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELINST?format=csv&settlementDateFrom=2023-01-01&settlementDateTo=2023-01-02').
          to_return(body:)
        expect(::Generation).to receive(:upsert_all)
        subject.cli(['2023-01-01','2023-01-02'])
      end
    end
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      area = Area.find_by! code: 'GB', source: 'elexon'
      production_type = ProductionType.find_by! name: 'wind'
      apt = AreasProductionType.find_by!(area:, production_type:)
      apt.generation.create time: datapoint_time, value: 1000
    end

    it do
      parser = double('Elexon::FuelInst')
      # FIXME don't call for tomorrow
      expect(parser).to receive(:process).twice
      expect(subject).to receive(:new).twice { parser }
      subject.parsers_each &:process
    end
  end
end

RSpec.describe Elexon::Load do
  subject { Elexon::Load }
  describe :cli

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      areas = Area.find_by! code: 'GB', source: 'elexon'
      areas.load.create time: datapoint_time, value: 10000000
    end

    it do
      parser = double('Elexon::Load')
      # FIXME don't call for tomorrow
      expect(parser).to receive(:process).twice
      expect(subject).to receive(:new).twice { parser }
      subject.parsers_each &:process
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
