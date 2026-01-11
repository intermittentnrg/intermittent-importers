require 'rails_helper'

RSpec.describe JapanJuyo::Rikuden do
  subject { JapanJuyo::Rikuden }

  around(:example) { |ex| VCR.use_cassette('japan_juyo_rikuden', &ex) }

  context '#cli end-to-end test' do
    it 'fetches and sends data to Out::Generation and Out::Load' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288) # 288 time points of solar data (5-minute intervals)
        expect(points.first[:country]).to eq('hokuriku')
        expect(points.first[:production_type]).to eq('solar')
        expect(source).to eq('rikuden')
      end

      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288) # 288 time points of load data (5-minute intervals)
        expect(points.first[:country]).to eq('hokuriku')
        expect(source).to eq('rikuden')
      end

      allow(DataFile).to receive(:last_modified)
      allow(DataFile).to receive(:upsert_all)

      subject.cli(['-d', '2023-01-01'])
    end
  end
end
