require 'spec_helper'
RSpec.describe Caiso::Generation do
  subject { Caiso::Generation }
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
end

RSpec.describe Caiso::Load do
  subject :e do
    VCR.use_cassette("caiso_load_#{date}") do
      Caiso::Load.new(date)
    end
  end

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
