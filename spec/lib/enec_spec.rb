# frozen_string_literal: true

require 'rails_helper'
require 'enec'

RSpec.describe Enec do
  let(:fixture_body) { File.read('spec/fixtures/enec.html') }
  let(:enec) { Enec.new }

  describe '#add' do
    it 'fetches and parses HTML from enec.gov.ae' do
      stub_request(:get, 'https://www.enec.gov.ae/')
        .to_return(body: fixture_body, headers: { 'Last-Modified' => 'Fri, 13 Feb 2026 15:00:00 GMT' })

      allow(Unit).to receive(:joins).and_return(
        double('relation', where: double('relation', pluck: [1]))
      )
      allow(AreasProductionType).to receive(:joins).and_return(
        double('relation', where: double('relation', pluck: [1]))
      )

      expect(GenerationUnitCounter).to receive(:upsert_all) do |data|
        expect(data.length).to eq(4)
        expect(data.first[:time].strftime('%Y-%m-%d %H:%M:%S')).to eq('2026-02-13 21:06:42')
        expect(data.map { |r| r[:value] }).to eq([49_527_555_700, 41_645_660_700, 30_023_420_700, 6_604_640_700])
      end

      expect(GenerationCounter).to receive(:upsert_all) do |data|
        expect(data.length).to eq(1)
        expect(data.first[:time].strftime('%Y-%m-%d %H:%M:%S')).to eq('2026-02-13 21:06:42')
        expect(data.first[:areas_production_type_id]).to eq(1)
      end

      enec.add.done!
    end

    it 'falls back to Last-Modified header when no actualDate in HTML' do
      body = '<html><body><div id="count-air-unit1">100</div></body></html>'
      stub_request(:get, 'https://www.enec.gov.ae/')
        .to_return(body:, headers: { 'Last-Modified' => 'Fri, 13 Feb 2026 15:00:00 GMT' })

      allow(Unit).to receive(:joins).and_return(
        double('relation', where: double('relation', pluck: [1]))
      )
      allow(AreasProductionType).to receive(:joins).and_return(
        double('relation', where: double('relation', pluck: [1]))
      )

      expect(GenerationUnitCounter).to receive(:upsert_all) do |data|
        expect(data.first[:time].strftime('%Y-%m-%d %H:%M:%S')).to eq('2026-02-13 15:00:00')
      end

      enec.add.done!
    end
  end

  describe '#parse_time' do
    it 'parses actualDate from HTML script' do
      doc = Nokogiri::HTML(fixture_body)
      time = enec.parse_time(doc)
      expect(time.strftime('%Y-%m-%d %H:%M:%S')).to eq('2026-02-13 21:06:42')
    end

    it 'falls back to last_modified when no actualDate' do
      doc = Nokogiri::HTML('<html><body></body></html>')
      time = enec.parse_time(doc)
      expect(time).to be false
    end
  end
end
