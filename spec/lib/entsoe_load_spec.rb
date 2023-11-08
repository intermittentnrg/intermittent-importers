require './spec/spec_helper'

RSpec.describe Entsoe::Load do
  subject { Entsoe::Load }
  subject(:e) do
    VCR.use_cassette("load_#{country}_#{from}_#{to}") do
      subject.new country:, from:, to:
    end
  end

  describe 'FR' do
    let(:country) { 'FR' }
    let(:from) { '2021-01-01' }
    let(:to) { '2021-01-02' }
    it { expect(subject.points).to have(24).items }
    it { expect(e.points.first.keys).to eq [:country, :time, :value] }

    describe 'error' do
      let(:from) { '2050-01-01' }
      let(:to) { '2050-01-02' }
      it { expect { e.points }.to raise_error(EmptyError)  }
    end
  end

  describe 'XK load 2023-07-27' do
    let(:country) { 'XK' }
    let(:from) { '2023-07-27' }
    let(:to) { '2023-07-28' }

    it { expect(e.points_load.map { |p| p[:value] }.max).to be < 1000000 }
    include_examples "logs error", "load"
  end
end
