require './spec/spec_helper'

RSpec.describe ENTSOE::Generation do
  describe 'DE' do
    subject do
      VCR.use_cassette("generation_de") do
        ENTSOE::Generation.new country: :DE, from: '2021-01-01', to: '2021-01-02'
      end
    end
    it { expect(subject.points.select { |p| p[:production_type] == 'wind_onshore' }.length).to be 24*4 }
  end

  describe 'FR' do
    subject do
      VCR.use_cassette("generation_fr") do
        ENTSOE::Generation.new country: :FR, from: '2021-01-01', to: '2021-01-02'
      end
    end
    it { expect(subject.points.select { |p| p[:production_type] == 'wind_onshore' }.length).to be 24 }
  end

  describe 'NO 2021-11-23' do
    subject do
      VCR.use_cassette("generation_no") do
        ENTSOE::Generation.new country: :NO, from: '2021-11-23', to: '2021-11-24'
      end
    end
    it { expect(subject.points.select { |p| p[:production_type] == 'wind_onshore' }.length).to be >= 18 }
    it { expect(subject.points.select { |p| p[:production_type] == 'wind_onshore' }.map { |p| p[:value] }.max ).to be < 10_000 }
    #it { require 'pry' ; binding.pry }
  end
end
