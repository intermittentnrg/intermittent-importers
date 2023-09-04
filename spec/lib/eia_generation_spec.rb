require './spec/spec_helper'

RSpec.describe Eia::Generation do
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
