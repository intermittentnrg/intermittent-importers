require './spec/spec_helper'

RSpec.describe ENTSOE::Price do
  subject(:e) do
    VCR.use_cassette("prices_#{country}") do
      ENTSOE::Price.new(country:, from: '2021-01-01', to: '2021-01-02').tap(&:points)
    end
  end
  describe 'SE1' do
    let(:country) { 'SE1' }
    it { expect(subject.points).to have(48).items }
    it { expect(e.points.first[:country]).to eq country }
  end
  describe 'DE-LU' do
    let(:country) { 'DE-LU' }
    it { expect(subject.points).to have(48).items }
  end
end
