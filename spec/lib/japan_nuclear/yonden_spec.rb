require 'rails_helper'

RSpec.describe JapanNuclear::Yonden do
  subject { JapanNuclear::Yonden }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('japan_nuclear_yonden', &ex) }

    it "fetches and sends data to Out::Generation and Out::Unit" do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1)
        expect(points.first[:country]).to eq('shikoku')
        expect(from).to be_nil
        expect(to).to be_nil
        expect(source).to eq('yonden')
      end

      expect(Out::Unit).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1)
        expect(points.map { |p| p[:unit] }.uniq).to eq ["ikata-3"]
        expect(points.first[:time]).to eq Time.parse('2026-02-05 06:40:00')
        expect(from).to be_nil
        expect(to).to be_nil
        expect(source).to eq('yonden')
      end

      subject.cli([])
    end
  end
end
