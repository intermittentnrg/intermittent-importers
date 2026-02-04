require 'spec_helper'

RSpec.describe HydroQuebec::Generation do
  subject { HydroQuebec::Generation }

  describe :cli do
    around { |ex| VCR.use_cassette('hydro_quebec_generation', &ex) }

    it "fetches and sends data to Out::Generation" do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('hydroquebec')

        # Check that we have the expected data structure
        point = points.first
        expect(point).to have_key(:time)
        expect(point).to have_key(:country)
        expect(point).to have_key(:production_type)
        expect(point).to have_key(:value)

        # Check specific values
        expect(point[:country]).to eq('CA-QC')
        expect(point[:value]).to be_a(Numeric)
        expect(point[:time]).to be_a(Time)
        expect(point[:production_type]).to be_a(Symbol)
      end
      subject.cli([])
    end
  end
end