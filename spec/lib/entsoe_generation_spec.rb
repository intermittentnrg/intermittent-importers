require './spec/spec_helper'

RSpec.describe ENTSOE::Generation do
  describe 'DE 2021-01-01' do
    subject(:e) do
      VCR.use_cassette("generation_de") do
        ENTSOE::Generation.new country: :DE, from: '2021-01-01', to: '2021-01-02'
      end
    end
    describe "wind_onshore" do
      subject(:wind_onshore) { e.points.select { |p| p[:tags][:production_type] == 'wind_onshore' } }
      #it { require 'pry' ; binding.pry }
      it { expect(subject).to have_at_least(24*4).items }
    end
    describe "tags" do
      it { expect(e.points.first[:tags].keys).to eq [:country, :process_type, :production_type] }
    end
  end

  describe 'FR 2021-01-01' do
    subject(:e) do
      VCR.use_cassette("generation_fr") do
        ENTSOE::Generation.new country: :FR, from: '2021-01-01', to: '2021-01-02'
      end
    end
    describe "wind_onshore" do
      subject(:wind_onshore) { e.points.select { |p| p[:tags][:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have(24).items }
    end
  end

  describe 'NO 2021-11-23' do
    subject(:e) do
      VCR.use_cassette("generation_no") do
        ENTSOE::Generation.new country: :NO, from: '2021-11-23', to: '2021-11-24'
      end
    end
    describe "wind_onshore" do
      subject(:wind_onshore) { e.points.select { |p| p[:tags][:production_type] == 'wind_onshore' } }
      it { expect(wind_onshore).to have_at_least(18).items }
      it "ignores values over 10GW" do
        expect(wind_onshore.map { |p| p[:value] }.max ).to be < 10_000
      end
    end
    #it { require 'pry' ; binding.pry }
  end
end
