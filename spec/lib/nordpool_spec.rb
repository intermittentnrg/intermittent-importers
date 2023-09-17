require './spec/spec_helper'

RSpec.describe Nordpool::Price do
  subject :points_se do
    e.points.filter { |row| row[:country] == "SE1" }
  end
  subject :hours_se do
    points_se.map {|r| r[:time].hour}
  end

  describe 'dst day 2021-10-31' do
    subject :e do
      VCR.use_cassette("nordpool_price_2021-10-31") do
        Nordpool::Price.new(DateTime.parse("2021-10-31"))
      end
    end
    it { expect(points_se).to have(25).items }
    it { expect(hours_se).to eq [22,23] + 0.upto(22).to_a }
  end
end

RSpec.describe Nordpool::Transmission do
  subject :points_se do
    e.points.filter { |row| row[:from_area] == "SE1" && row[:to_area] == "SE2" }
  end
  subject :hours_se do
    points_se.map {|r| r[:time].hour}
  end

  describe 'regular day 2021-10-30' do
    subject :e do
      VCR.use_cassette("nordpool_2021-10-30") do
        Nordpool::Transmission.new(DateTime.parse("2021-10-30"))
      end
    end
    it { expect(points_se).to have(24).items }
    it { expect(hours_se).to eq [22,23] + 0.upto(21).to_a }
  end
  describe 'dst day 2021-10-31' do
    subject :e do
      VCR.use_cassette("nordpool_2021-10-31") do
        Nordpool::Transmission.new(DateTime.parse("2021-10-31"))
      end
    end
    it { expect(points_se).to have(25).items }
    it { expect(hours_se).to eq [22,23] + 0.upto(22).to_a }
  end
  describe 'dst day 2022-03-27' do
    subject :e do
      VCR.use_cassette("nordpool_2022-03-27") do
        Nordpool::Transmission.new(DateTime.parse("2022-03-27"))
      end
    end
    it { expect(points_se).to have(23).items }
    it { expect(hours_se).to eq [23] + 0.upto(21).to_a }
  end
end

RSpec.describe Nordpool::Capacity do
  subject { Nordpool::Capacity }
  around(:example) { |ex| VCR.use_cassette('nordpool_capacity', &ex) }
  context 'with date range' do
    let(:args) { ['2023-01-01', '2023-01-02'] }
    it do
      expect(Transmission).to receive(:upsert_all)
      subject.cli(args)
    end
  end
end

RSpec.describe Nordpool::CapacityChart do
  subject { Nordpool::CapacityChart }
  around(:example) { |ex| VCR.use_cassette('nordpool_capacity_chart', &ex) }
  context 'with date range' do
    let(:args) { ['2023-01-01', '2023-01-01'] }
    it do
      expect(Transmission).to receive(:upsert_all)
      subject.cli(args)
    end
  end
end
