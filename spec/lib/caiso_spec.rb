require 'spec_helper'
require 'timecop'

RSpec.describe Caiso::FuelSource do
  subject { Caiso::FuelSource }
  describe :cli do
    context 'with date range' do
      around(:example) { |ex| VCR.use_cassette("caiso_generation", &ex) }
      let(:args) { ['2023-01-01', '2023-01-02'] }
      it do
        expect(Generation).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end
  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:datapoint_time) { subject::TZ.local_to_utc(Time.new(2022,12,31,22)) }
    before do
      area = Area.find_by! code: 'CAISO', source: 'caiso'
      production_type = ProductionType.find_by! name: 'solar'
      apt = area.areas_production_type.find_by!(production_type:)
      apt.generation.create(time: datapoint_time, value: 1000)
    end
    context "refreshes previous day if data missing" do
      let(:current_time) { Time.new(2023,1,1,6) }
      it do
        req = stub_request(:get, 'https://www.caiso.com/outlook/history/20221231/fuelsource.csv').
                to_return(body: '\n')
        allow(Time).to receive(:strptime)
        subject.parsers_each(&:fetch)
        expect(req).to have_been_requested
      end
    end
  end
end

RSpec.describe Caiso::Load do
  subject { Caiso::Load }
  context do
    around(:example) { |ex| VCR.use_cassette("caiso_load_#{date}", &ex) }
    subject(:e) { Caiso::Load.new(date) }

    before do
      datafile = double('DataFile')
      expect(DataFile).to receive(:where) { datafile }
      expect(datafile).to receive(:pluck) { datafile }
      expect(datafile).to receive(:first) { nil }
    end
    describe 'dst 2019-03-10' do
      subject(:date) { Date.new(2019,3,10) }
      it("has 23h*5m datapoints") { expect(e.points_load).to have(23*12).items }
    end

    describe 'dst 2019-11-03' do
      subject(:date) { Date.new(2019,11,3) }
      # should be 25 but netdemand.csv/website is retarded. OK.
      it("has 24h*5m datapoints") { expect(e.points_load).to have(24*12).items }
    end
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:datapoint_time) { subject::TZ.local_to_utc(Time.new(2022,12,31,22)) }
    before do
      area = Area.find_by! code: 'CAISO', source: 'caiso'
      area.load.create time: datapoint_time, value: 1000
    end
    context "refreshes previous day if data missing" do
      let(:current_time) { Time.new(2023,1,1,6) }
      it do
        req = stub_request(:get, 'https://www.caiso.com/outlook/history/20221231/netdemand.csv').
                to_return(body: '\n')
        allow(Time).to receive(:strptime)
        subject.parsers_each(&:fetch)
        expect(req).to have_been_requested
      end
    end
  end
end
