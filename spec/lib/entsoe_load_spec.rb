require './spec/spec_helper'

RSpec.describe ENTSOE::Load do
  it { expect(ENTSOE::COUNTRIES[:FR]).to be }

  describe 'FR' do
    subject do
      VCR.use_cassette("load_fr") do
        ENTSOE::Load.new country: :FR, from: '2021-01-01', to: '2021-01-02'
      end
    end
    it { expect(subject.points).to be }
  end
end
