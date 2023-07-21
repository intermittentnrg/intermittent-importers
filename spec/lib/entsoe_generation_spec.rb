require './spec/spec_helper'

RSpec.describe ENTSOE::Generation do
  subject(:e) do
    VCR.use_cassette("generation_#{country}") do
      ENTSOE::Generation.new country:, from: '2021-01-01', to: '2021-01-02'
    end
  end
  describe 'DE 2021-01-01' do
    let(:country) { 'DE' }
    describe "wind_onshore" do
      subject(:wind_onshore) { e.points.select { |p| p[:production_type] == 'wind_onshore' } }
      it { expect(subject).to have_at_least(24*4).items }
    end
    describe "tags" do
      it { expect(e.points.first.keys).to eq [:country, :production_type, :time, :value] }
    end
  end

  describe 'FR 2021-01-01' do
    let(:country) { 'FR' }
    describe "wind_onshore" do
      subject(:wind_onshore) { e.points.select { |p| p[:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have(24).items }
    end
  end

  describe 'NO 2021-11-23' do
    let(:country) { 'NO' }
    describe "wind_onshore" do
      subject(:wind_onshore) { e.points.select { |p| p[:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have_at_least(18).items }
      it "ignores values over 10GW" do
        expect(wind_onshore.map { |p| p[:value] }.max ).to be < 10_000
      end
    end
    #it { require 'pry' ; binding.pry }
  end
end
