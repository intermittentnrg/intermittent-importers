require 'spec_helper'

RSpec.describe Aeso::Generation do
  subject { Aeso::Generation }
  around(:example) { |ex| VCR.use_cassette('aeso_generation', &ex) }
  describe :cli do
    it do
      expect(Generation).to receive(:upsert_all)
      subject.cli([])
    end
  end
  describe '#points_generation' do
    it "has correct generation" do
      points = subject.new.points_generation
      hydro = points.select { |p| p[:production_type] == 'hydro' }
      first = points.first
      expect(hydro.first[:value]).to eq 113000
    end
  end
end
