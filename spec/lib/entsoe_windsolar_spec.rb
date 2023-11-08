require './spec/spec_helper'

RSpec.describe Entsoe::WindSolar do
  subject { Entsoe::WindSolar }
#  describe 'FR' do
#    subject(:e) do
#      VCR.use_cassette("windsolar_fr") do
#        subject.new country: :FR, from: '2021-01-01', to: '2021-01-02'
#      end
#    end
#    it { expect(subject.points).to have_at_least(24).items }
#    describe "tags" do
#      it { expect(e.points.first[:tags].keys).to eq [:country] }
#    end
#  end
end
