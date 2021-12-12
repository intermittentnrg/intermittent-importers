require './spec/spec_helper'

RSpec.describe ENTSOE::Load do
  it { expect(ENTSOE::COUNTRIES[:FR]).to be }

  describe 'FR' do
    subject(:e) do
      VCR.use_cassette("load_fr") do
        ENTSOE::Load.new country: :FR, from: '2021-01-01', to: '2021-01-02'
      end
    end
    it { expect(subject.points).to have_at_least(24).items }
    describe "tags" do
      it { expect(e.points.first[:tags].keys).to eq [:country] }
    end
  end
end
