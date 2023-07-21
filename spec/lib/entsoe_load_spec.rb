require './spec/spec_helper'

RSpec.describe ENTSOE::Load do
  let(:from) { '2021-01-01' }
  let(:to) { '2021-01-02' }
  subject(:e) do
    VCR.use_cassette("load_#{country}_#{from}_#{to}") do
      ENTSOE::Load.new country:, from:, to:
    end
  end

  describe 'FR' do
    let(:country) { 'FR' }
    it { expect(subject.points).to have(24).items }
    it { expect(e.points.first.keys).to eq [:country, :time, :value] }

    describe 'error' do
      let(:from) { '2050-01-01' }
      let(:to) { '2050-01-02' }
      it { expect { e.points }.to raise_error(ENTSOE::EmptyError)  }
    end
  end
end
