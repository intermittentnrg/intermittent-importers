require './spec/spec_helper'

RSpec.describe Ree::Generation do
  subject { Ree::Generation }

  around(:example) { |ex| VCR.use_cassette('ree_generation', &ex) }

  context '#cli end-to-end test' do
    it 'should process date range and call Out::Generation.run with correct data structure' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1805)
        expect(points.first[:country]).to eq('ES-CN-FVLZ')
        expect(points.first[:production_type]).to be_in(['fossil_oil', 'fossil_gas', 'wind_onshore', 'solar', 'hydro_pumped_storage'])
        expect(source).to eq('ree')
      end

      subject.cli(['2023-01-01', '2023-01-02'])
    end
  end
end
