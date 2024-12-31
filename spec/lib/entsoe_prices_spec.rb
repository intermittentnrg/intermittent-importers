require './spec/spec_helper'

RSpec.describe Entsoe::Price do
  subject(:e) do
    VCR.use_cassette("prices_#{country}") do
      Entsoe::Price.new(country:, from: '2021-01-01', to: '2021-01-02').tap(&:points)
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
  context 'gapfill' do
    subject(:e) do
      VCR.use_cassette("prices_gapfill") do
        Entsoe::Price.new(country: 'PT', from: '2024-12-29', to: '2024-12-29')
      end
    end
    it { expect(subject.points).to have(24).items }
    it { expect(subject.points).to include(include(time: Time.parse('2024-12-29 04:00:00 UTC'))) }
  end
end
