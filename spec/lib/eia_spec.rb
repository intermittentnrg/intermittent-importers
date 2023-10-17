require './spec/spec_helper'

RSpec.describe Eia::Generation do
  subject { Eia::Generation }
  context do
    subject(:e) do
      VCR.use_cassette("generation_#{country}_#{from}_#{to}") do
        Eia::Generation.new(country:, from: Date.parse(from), to: Date.parse(to))
      end
    end
    describe 'EIA BANC gas validation' do
      let(:country) { 'BANC' }
      let(:from) { '2019-07-25' }
      let(:to) { '2019-07-26' }
      it { expect(e.points_generation.map { |p| p[:value] }.max).to be < 400000000 }
      include_examples "logs error", "generation"
    end
  end

  describe :cli do
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    around(:example) { |ex| VCR.use_cassette('eia_generation_parsers_each', &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      areas = Area.find_by! code: 'CISO', source: 'eia'
      production_type = ProductionType.find_by! name: 'wind'
      apt = areas.areas_production_type.find_by!(production_type:)
      areas.generation.create(time: datapoint_time, production_type:, areas_production_type_id: apt.id, value: 1000)
    end

    it do
      expect(::Generation).to receive(:upsert_all)
      subject.parsers_each &:process
    end
  end
end

RSpec.describe Eia::Load do
  subject { Eia::Load }

  describe :cli do
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    around(:example) { |ex| VCR.use_cassette('eia_load_parsers_each', &ex) }
    let(:current_time) { Time.new(2023,1,1) }
    let(:datapoint_time) { Time.new(2023,1,1) }
    before do
      areas = Area.find_by! code: 'BANC', source: 'eia'
      areas.load.create time: datapoint_time, value: 1000
    end

    it do
      expect(::Load).to receive(:upsert_all)
      subject.parsers_each &:process
    end
  end
end
