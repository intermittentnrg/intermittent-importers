# frozen_string_literal: true

require 'rails_helper'
require 'enec'

RSpec.describe Enec do
  let(:fixture_body) { File.read('spec/fixtures/enec.html') }
  let(:enec) { Enec.new }

  describe '#add_file' do
    it 'parses HTML from file' do
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

      enec.add_file('spec/fixtures/enec.html').done!
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

  describe :refresh do
    let(:sqs) { double('SQS') }
    let(:result) { double('SQS::result') }
    let(:message) { double('SQS::message', body: fixture_body, receipt_handle: '123') }
    let(:messages) { [message] }
    let(:delete_result) { double('SQS::delete_message_batch result', length: 0) }

    before do
      allow(Aws::SQS::Client).to receive(:new) { sqs }
      allow(sqs).to receive(:receive_message) { result }
      allow(result).to receive(:messages) { messages }
      allow(Unit).to receive(:joins).and_return(
        double('relation', where: double('relation', pluck: [1]))
      )
      allow(AreasProductionType).to receive(:joins).and_return(
        double('relation', where: double('relation', pluck: [1]))
      )
      expect(sqs).to receive(:delete_message_batch) { delete_result }
    end

    it 'processes messages from SQS' do
      expect(GenerationUnitCounter).to receive(:upsert_all) do |data|
        expect(data.length).to eq(4)
      end
      expect(GenerationCounter).to receive(:upsert_all) do |data|
        expect(data.length).to eq(1)
      end

      Enec.refresh
    end
  end
end
