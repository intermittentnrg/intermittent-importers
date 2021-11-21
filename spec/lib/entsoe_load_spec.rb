require 'rspec'
require './lib/entsoe'

RSpec.describe ENTSOE::Load do
  it { expect(ENTSOE::COUNTRIES[:FR]).to be }

  describe 'FR' do
    subject do
      ENTSOE::Load.new country: :FR, from: '2021-01-01', to: '2021-01-02'
    end
    it { expect(subject.points).to be }
  end
end
