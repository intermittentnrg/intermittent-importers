require 'rails_helper'

RSpec.describe JapanJuyo::Tepco do
  subject { JapanJuyo::Tepco }

  around(:example) { |ex| VCR.use_cassette('japan_juyo_tepco', &ex) }

  context '#cli end-to-end test' do
    it 'fetches and sends data to Out::Generation and Out::Load' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288)  # 288 solar points (5-min intervals)
        expect(points.first[:country]).to eq('tokyo')
        expect(points.first[:production_type]).to eq('solar')
        expect(source).to eq('tepco')
      end

      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(288)  # 288 load points
        expect(points.first[:country]).to eq('tokyo')
        expect(source).to eq('tepco')
      end

      allow(DataFile).to receive(:last_modified)
      allow(DataFile).to receive(:upsert_all)

      subject.cli(['-d'])
    end
  end
end
