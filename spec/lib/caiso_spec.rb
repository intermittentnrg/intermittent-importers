require 'rails_helper'
require 'timecop'

RSpec.describe Caiso::FuelSource do
  subject { Caiso::FuelSource }
  describe :cli do
    context 'with date range' do
      around(:example) { |ex| VCR.use_cassette("caiso_generation", &ex) }
      let(:args) { ['2023-01-01', '2023-01-02'] }
      it do
        expect(Out::Generation).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(3456)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source).to eq('caiso')
        end
        expect(Out::Transmission).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(288)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source).to eq('caiso')
        end
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              path: 'https://www.caiso.com/outlook/history/20230101/fuelsource.csv',
              source: 'caiso',
              updated_at: Time.httpdate('Wed, 04 Jan 2023 12:03:19 GMT')
            )
          ),
          unique_by: [:source, :path]
        )
        subject.cli(args)
      end
    end
  end
  describe :each do
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
        req = stub_request(:get, 'https://www.caiso.com/outlook/history/20221231/fuelsource.csv')
              .to_return(body: "Time,Solar,Wind,Geothermal,Biomass,Biogas,Small hydro,Coal,Nuclear,Natural Gas,Large Hydro,Batteries,Imports,Other\r\n")
        allow(Time).to receive(:httpdate)
        subject.each do |date|
          subject.new.add(date).done!
        end
        expect(req).to have_been_requested
      end
    end
  end
end

RSpec.describe Caiso::Load do
  subject { Caiso::Load }
  context do
    around(:example) { |ex| VCR.use_cassette("caiso_load_#{date}", &ex) }
    subject(:e) { Caiso::Load.new.add_date(date) }

    before do
      datafile = double('DataFile')
      expect(DataFile).to receive(:where) { datafile }
      expect(datafile).to receive(:pluck) { datafile }
      expect(datafile).to receive(:first) { nil }
    end
    describe 'dst 2019-03-10' do
      subject(:date) { Date.new(2019,3,10) }
      it("has 23h*5m datapoints") { expect(e.instance_variable_get(:@r_load)).to have(23*12).items }
    end

    describe 'dst 2019-11-03' do
      subject(:date) { Date.new(2019,11,3) }
      # should be 25 but netdemand.csv/website is retarded. OK.
      it("has 24h*5m datapoints") { expect(e.instance_variable_get(:@r_load)).to have(24*12).items }
    end

    describe 'upserts datafile on done!' do
      subject(:date) { Date.new(2019,3,10) }
      it do
        expect(Out::Load).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(23*12)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source).to eq('caiso')
        end
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              source: 'caiso'
            )
          ),
          unique_by: [:source, :path]
        )
        e.done!
      end
    end
  end

  describe :each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    let(:datapoint_time) { subject::TZ.local_to_utc(Time.new(2022,12,31,22)) }
    before do
      area = Area.find_by! code: 'CAISO', source: 'caiso'
      area.load.create time: datapoint_time, value: 1000
    end
    context "refreshes previous day if data missing" do
      let(:current_time) { Time.new(2023,1,1,6) }
      it do
        req = stub_request(:get, 'https://www.caiso.com/outlook/history/20221231/netdemand.csv')
              .to_return(body: "Time,Hour ahead forecast,Current demand,Net demand\r\n")
        allow(Time).to receive(:httpdate)
        subject.each do |date|
          subject.new.add(date).done!
        end
        expect(req).to have_been_requested
      end
    end
  end
end

RSpec.describe Caiso::Price do
  subject { Caiso::Price }
  describe :cli do
    context 'with date range' do
      around(:example) { |ex| VCR.use_cassette("caiso_price_sp15", &ex) }
      let(:args) { ['2023-01-01', '2023-01-02'] }
      it do
        expect(Out::Price).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(48)
          expect(from).to be_a(Time)
          expect(to).to be_a(Time)
          expect(source).to eq('caiso')
          expect(points.first[:country]).to eq('CAISO')
          expect(points.first[:value]).to be_an(Integer)
        end
        subject.cli(args)
      end
    end

    context 'with single date' do
      around(:example) { |ex| VCR.use_cassette("caiso_price_sp15_single", &ex) }
      let(:args) { ['2023-01-01'] }
      it do
        expect(Out::Price).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(24)
          expect(source).to eq('caiso')
        end
        subject.cli(args)
      end
    end
  end

  describe :add_date_range do
    around(:example) { |ex| VCR.use_cassette("caiso_price_sp15", &ex) }
    subject(:e) { Caiso::Price.new.add_date_range(Date.new(2023, 1, 1), Date.new(2023, 1, 2)) }

    it 'parses LMP prices from ZIP/XML response for date range' do
      expect(e.instance_variable_get(:@r_price)).to have(48).items
    end

    it 'converts $/MWh to cents' do
      prices = e.instance_variable_get(:@r_price)
      prices.each do |price|
        expect(price[:value]).to be_an(Integer)
        expect(price[:value]).to be > 0
      end
    end

    it 'sets valid UTC timestamps' do
      prices = e.instance_variable_get(:@r_price)
      prices.each do |price|
        expect(price[:time]).to be_a(Time)
        expect(price[:time].utc?).to be true
      end
    end
  end

  describe :done! do
    around(:example) { |ex| VCR.use_cassette("caiso_price_sp15", &ex) }
    subject(:e) { Caiso::Price.new.add_date_range(Date.new(2023, 1, 1), Date.new(2023, 1, 2)) }

    it 'sends data to Out::Price' do
      expect(Out::Price).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(48)
        expect(source).to eq('caiso')
      end
      e.done!
    end

    it 'does not call Out::Price if data is empty' do
      empty_price = Caiso::Price.new
      expect(Out::Price).not_to receive(:run)
      empty_price.done!
    end
  end
end
