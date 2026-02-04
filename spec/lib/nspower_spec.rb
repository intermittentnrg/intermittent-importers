require 'rails_helper'

RSpec.describe Nspower::Combined do
  subject { Nspower::Combined }

  describe :cli do
    around { |ex| VCR.use_cassette('nspower_combined', &ex) }

    it "fetches and sends data to Out::Generation and Out::Load" do
      expect(Out::Generation).to receive(:run) do |gen_points, from, to, source|
        expect(gen_points.length).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('nspower')

        # Check that we have the expected data structure
        gen_point = gen_points.first
        expect(gen_point).to have_key(:time)
        expect(gen_point).to have_key(:country)
        expect(gen_point).to have_key(:production_type)
        expect(gen_point).to have_key(:value)

        # Check specific values
        expect(gen_point[:country]).to eq('CA-NS')
        expect(gen_point[:value]).to be_a(Numeric)
        expect(gen_point[:time]).to be_a(Time)
        expect([:biomass, :coal, :gas, :hydro, :oil, :wind]).to include(gen_point[:production_type])
      end

      expect(Out::Load).to receive(:run) do |load_points, from, to, source|
        expect(load_points.length).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('nspower')

        # Check that we have the expected data structure
        load_point = load_points.first
        expect(load_point).to have_key(:time)
        expect(load_point).to have_key(:country)
        expect(load_point).to have_key(:value)

        # Check specific values
        expect(load_point[:country]).to eq('CA-NS')
        expect(load_point[:value]).to be_a(Numeric)
        expect(load_point[:time]).to be_a(Time)
      end

      subject.cli([])
    end
  end
end
