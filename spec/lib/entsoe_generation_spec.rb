require './spec/spec_helper'

RSpec.describe Entsoe::Generation do
  subject { Entsoe::Generation }
  let(:e) do
    VCR.use_cassette("generation_#{country}_#{from}_#{to}") do
      subject.new(country:, from:, to:)
    end
  end
  let(:from) { Date.new 2021, 01, 01 }
  let(:to) { Date.new 2021, 01, 02 }

  describe 'DE 2021-01-01' do
    let(:country) { 'DE' }
    describe "wind_onshore" do
      let(:wind_onshore) { e.points.select { |p| p[:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have_at_least(24*4).items }
    end
    describe "tags" do
      it { expect(e.points.first.keys).to eq [:country, :production_type, :time, :value] }
    end
    describe :process do
      it do
        expect(Generation).to receive(:upsert_all)
        e.process_generation
      end
    end
  end

  describe 'FR 2021-01-01' do
    let(:country) { 'FR' }
    describe "wind_onshore" do
      let(:wind_onshore) { e.points.select { |p| p[:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have(24).items }
    end
  end

  xdescribe 'NO 2021-11-23' do
    let(:country) { 'NO' }
    let(:from) { Date.new 2021, 11, 23 }
    let(:to) { Date.new 2021, 11, 24 }
    describe "wind_onshore" do
      let(:wind_onshore) { e.points.select { |p| p[:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have_at_least(18).items }
      it "ignores values over 10GW" do
        expect(wind_onshore.map { |p| p[:value] }.max ).to be < 10_000
      end
      include_examples "logs error", "generation"
    end
    #it { require 'pry' ; binding.pry }
  end
end
