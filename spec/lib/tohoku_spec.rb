require './spec/spec_helper'

RSpec.describe Tohoku::Juyo do
  subject { Tohoku::Juyo }
  
  around(:example) { |ex| VCR.use_cassette('tohoku', &ex) }

  context '#cli end-to-end test' do
    it 'should process date and call Out::Generation.run and Out::Load.run with correct data structure' do
      # Expect Out::Generation.run to be called with the processed generation data
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(576) # 288 time points * 2 production types (solar, wind)
        expect(points.first[:country]).to eq('tohoku')
        expect(points.first[:production_type]).to be_in(['solar', 'wind'])
        expect(source).to eq('tohoku-epco')
      end

      # Expect Out::Load.run to be called with the processed load data
      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288) # 288 time points of load data (5-minute intervals)
        expect(points.first[:country]).to eq('tohoku')
        expect(source).to eq('tohoku-epco')
      end

      subject.cli(['2023-01-01'])
    end
  end
end