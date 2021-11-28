require './spec/spec_helper'

RSpec.describe ENTSOE::WindSolar do
  describe 'FR' do
    subject do
      VCR.use_cassette("windsolar_fr") do
        ENTSOE::WindSolar.new country: :FR, from: '2021-01-01', to: '2021-01-02'
      end
    end
    it { expect(subject.points).to have_at_least(24).items }
  end
end
