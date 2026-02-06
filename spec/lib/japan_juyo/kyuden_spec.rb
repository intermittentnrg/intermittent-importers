require 'spec_helper'

RSpec.describe JapanJuyo::Kyuden do
  subject { JapanJuyo::Kyuden }

  around(:example) { |ex| VCR.use_cassette('japan_juyo_kyuden', &ex) }

  context '#cli end-to-end test' do
    it 'fetches and sends data to Out::Generation and Out::Load' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288) # 288 time points of solar data (5-minute intervals)
        expect(points.first[:country]).to eq('kyushu')
        expect(points.first[:production_type]).to eq('solar')
        expect(source).to eq('kyuden')
      end

      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288) # 288 time points of load data (5-minute intervals)
        expect(points.first[:country]).to eq('kyushu')
        expect(source).to eq('kyuden')
      end

      allow(DataFile).to receive(:last_modified)
      allow(DataFile).to receive(:upsert_all)

      subject.cli(['-d', '2023-01-01'])
    end
  end
end
