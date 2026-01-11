require 'rails_helper'

RSpec.describe JapanNuclear::Kepco do
  subject { JapanNuclear::Kepco }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('japan_nuclear_kepco', &ex) }

    it "fetches and sends data to Out::Generation and Out::Unit" do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1)
        expect(points.first[:country]).to eq('kansai')
        expect(from).to be_nil
        expect(to).to be_nil
        expect(source).to eq('kepco')
      end

      expect(Out::Unit).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(7)
        expect(points.map { |p| p[:unit] }.uniq).to eq ["mihama-3", "takahama-1", "takahama-2", "takahama-3", "takahama-4", "ooi-3", "ooi-4"]
        expect(points.first[:time]).to eq Time.parse('2026-02-05 06:30:00')
        expect(points.first[:country]).to eq('kansai')
        expect(from).to be_nil
        expect(to).to be_nil
        expect(source).to eq('kepco')
      end

      subject.cli([])
    end
  end
end
