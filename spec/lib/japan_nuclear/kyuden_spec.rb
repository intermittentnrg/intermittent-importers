require 'rails_helper'

RSpec.describe JapanNuclear::Kyuden do
  subject { JapanNuclear::Kyuden }

  around(:example) { |ex| VCR.use_cassette('japan_nuclear_kyuden', &ex) }

  describe :cli do
    it 'fetches and sends data to Out::Generation and Out::Unit' do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1)
        expect(points.first[:country]).to eq('kyushu')
        expect(from).to be_nil
        expect(to).to be_nil
        expect(source).to eq('kyuden')
      end

      expect(Out::Unit).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(3) # 1 Sendai + 2 Genkai with active power
        expect(points.map { |p| p[:unit] }.uniq).to eq ["sendai-1", "genkai-3", "genkai-4"]
        expect(points.first[:time]).to eq Time.parse('2026-02-06 10:30:00')
        expect(from).to be_nil
        expect(to).to be_nil
        expect(source).to eq('kyuden')
      end

      subject.cli([])
    end
  end
end
