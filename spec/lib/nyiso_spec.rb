# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Nyiso::Generation do
  subject { Nyiso::Generation }

  describe :cli do
    around { |ex| VCR.use_cassette('nyiso_generation', &ex) }

    it 'fetches and sends data to Out::Generation' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq 2058
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('nyiso')

        point = points.first
        expect(point).to have_key(:time)
        expect(point).to have_key(:country)
        expect(point).to have_key(:production_type)
        expect(point).to have_key(:value)

        expect(point[:country]).to eq('US-NY')
        expect(point[:value]).to be_a(Numeric)
        expect(point[:time]).to be_a(Time)
        expect(point[:production_type]).to be_a(String)
      end
      subject.cli([(Date.today - 1).to_s])
    end
  end
end

RSpec.describe Nyiso::GenerationHistory do
  subject { Nyiso::GenerationHistory }

  describe :cli do
    around { |ex| VCR.use_cassette('nyiso_generation_history', &ex) }

    it 'fetches and sends data to Out::Generation' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq 2016
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('nyiso')

        point = points.first
        expect(point).to have_key(:time)
        expect(point).to have_key(:country)
        expect(point).to have_key(:production_type)
        expect(point).to have_key(:value)

        expect(point[:country]).to eq('US-NY')
        expect(point[:value]).to be_a(Numeric)
        expect(point[:time]).to be_a(Time)
        expect(point[:production_type]).to be_a(String)
      end
      subject.cli(['2023-01-01'])
    end
  end
end
