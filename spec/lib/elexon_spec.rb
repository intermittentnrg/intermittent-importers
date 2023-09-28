require 'spec_helper'

RSpec.describe Elexon::Generation do
  subject { Elexon::Generation }
  describe :cli do
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      areas = Area.find_by! code: 'GB', source: 'elexon'
      production_type = ProductionType.find_by! name: 'wind'
      areas.generation.create time: datapoint_time, production_type:, value: 1000
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
  describe :cli

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      areas = Area.find_by! code: 'GB', source: 'elexon'
      production_type = ProductionType.find_by! name: 'wind'
      areas.generation.create time: datapoint_time, production_type:, value: 1000
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
      areas.load.create time: datapoint_time, value: 1000
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
Actual Generation Output Per Generation Unit (B1610)
Time Series ID,Registered Resource  EIC Code,BM Unit ID,NGC BM Unit ID,PSR Type,Market Generation Unit EIC Code,Market Generation BMU ID,Market Generation NGC BM Unit ID,Settlement Date,SP,Quantity (MW)
ELX-EMFIP-AGOG-TS-8926,48W00000HYWDW-1G,E_HYWDW-1,HYWDW-1,Generation,48W00000HYWDW-1G,E_HYWDW-1,HYWDW-1,2023-09-01,20,0.148
CSV
  end
  let(:unit_id) { 'HYWDW-1' }

  before do
    stub_request(:get, %r|https://api\.bmreports\.com/BMRS/B1610/v2\?APIKey=.*&Period=\*&ServiceType=csv&SettlementDate=2023-09-01|).
      to_return(body:)
  end
  describe :cli do
    context 'with date range and unit' do
      let(:args) { ['2023-09-01', '2023-09-02'] }
      it do
        expect(::GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end

  let(:current_time) { Time.new(2016, 12, 5, 12) }
  describe :refresh_to do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    it do
      expect(subject.refresh_to).to eq Time.new(2016,11,28,12)
    end
  end

  describe :parsers_each do
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
          subject.parsers_each(&b)
        }.not_to yield_with_args
      end
    end

    context "skips last 4 business days" do
      let!(:parser) { double('Elexon::Unit') }
      let(:time) { Time.new(2016,11,27) }
      it do
        parser = double('Elexon::Unit')
        expect(Elexon::Unit).to receive(:new).with(Time.new(2016,11,27)) { parser }
        expect(Elexon::Unit).to receive(:new).with(Time.new(2016,11,28)) { parser }
        expect { |b|
          subject.parsers_each(&b)
        }.to yield_successive_args(parser, parser)
      end
    end
  end

  # TODO The units for generation data before the 10th July 2015 were expressed in MWh instead of MW. As a result, generation data published after 9th July was increased by a factor of 2 to account for the unit change from MWh to MW.
end
