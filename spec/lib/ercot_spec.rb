require 'rails_helper'

RSpec.describe Ercot::Generation do
  subject { Ercot::Generation }

  describe :cli do
    around { |ex| VCR.use_cassette('ercot_generation', &ex) }

    it 'fetches and sends data to Out::Generation' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to be > 0
        expect(points.first[:country]).to eq('ERCOT')
        expect(points.first[:production_type]).to be_a(String)
        expect(points.first[:value]).to be_a(Numeric)
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('ercot')
      end
      subject.cli([])
    end

    it 'raises error with more than one argument' do
      expect { subject.cli(%w[a b]) }.to raise_error(/At most one argument/)
    end
  end
end
