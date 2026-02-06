require 'spec_helper'

RSpec.describe JapanJuyo::Tohoku do
  subject { JapanJuyo::Tohoku }

  around(:example) { |ex| VCR.use_cassette('japan_juyo_tohoku', &ex) }

  context '#cli end-to-end test' do
    it 'should process date and call Out::Generation.run and Out::Load.run with correct data structure' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(576) # 288 time points * 2 production types (solar, wind)
        expect(points.first[:country]).to eq('tohoku')
        expect(points.first[:production_type]).to be_in(['solar', 'wind'])
        expect(source).to eq('tohoku-epco')
      end

      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288) # 288 time points of load data (5-minute intervals)
        expect(points.first[:country]).to eq('tohoku')
        expect(source).to eq('tohoku-epco')
      end

      allow(DataFile).to receive(:last_modified)
      allow(DataFile).to receive(:upsert_all)

      subject.cli(['-d', '2023-01-01'])
    end
  end
end
