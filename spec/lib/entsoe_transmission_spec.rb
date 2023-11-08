require './spec/spec_helper'

RSpec.describe Entsoe::Transmission do
  subject { Entsoe::Transmission }
  let(:from) { '2021-01-01' }
  let(:to) { '2021-01-02' }
  let(:from_area) { 'SE4' }
  let(:to_area) { 'DE-LU' }
  subject(:e) do
    VCR.use_cassette("transmission_#{from_area}_#{to_area}_#{from}_#{to}") do
      subject.new(from:, to:, from_area:, to_area:)
    end
  end

  it { expect(subject.points).to have(24).items }
  it { expect(e.points.first.keys).to eq [:time, :from_area, :to_area, :value] }
end
