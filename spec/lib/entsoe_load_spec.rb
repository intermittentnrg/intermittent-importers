require './spec/spec_helper'

RSpec.describe Entsoe::Load do
  subject { Entsoe::Load }
  let(:e) do
    VCR.use_cassette("load_#{country}_#{from}_#{to}") do
      subject.new(country:, from:, to:)
    end
  end

  describe 'FR' do
    let(:country) { 'FR' }
    let(:from) { Date.new 2021, 01, 01 }
    let(:to) { Date.new 2021, 01, 02 }
    it { expect(e.points).to have(24).items }
    it { expect(e.points.first.keys).to eq [:country, :time, :value] }

    describe 'error' do
      let(:from) { Date.new 2050, 01, 01 }
      let(:to) { Date.new 2050, 01, 02 }
      it { expect { e.points }.to raise_error(EmptyError)  }
    end
  end
end
