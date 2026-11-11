# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ons do
  subject { Ons }
  let :path do
    'spec/fixtures/ons.json'
  end

  describe :cli do
    it do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to be > 0
        expect(points.map { |p| p[:country] }.uniq).to eq(%w[BR-NE BR-N BR-CS BR-S])
        expect(from).to be
        expect(to).to be
        expect(source).to eq('ons')
      end
      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to be > 0
        expect(points.map { |p| p[:country] }.uniq).to eq(%w[BR-NE BR-N BR-CS BR-S])
        expect(from).to be
        expect(to).to be
        expect(source).to eq('ons')
      end
      expect(Out::Transmission).to receive(:run) do |points, from, to, source|
        expect(points.length).to be > 0
        expect(from).to be
        expect(to).to be
        expect(source).to eq('ons')
      end
      subject.cli([path])
    end

    context 'with invalid data' do
      let(:path) { 'spec/fixtures/ons-invalid.json' }
      it 'rejects all bogus data' do
        expect(Out::Generation).to receive(:run) do |points, _from, _to, _source|
          expect(points).to be_empty
        end
        expect(Out::Load).to receive(:run) do |points, _from, _to, _source|
          expect(points).to be_empty
        end
        expect(Out::Transmission).to receive(:run) do |points, _from, _to, _source|
          expect(points).to be_empty
        end
        subject.cli([path])
      end
    end
  end

  describe :refresh do
    let(:sqs) { double('SQS') }
    let(:result) { double('SQS::result') }
    let(:message) { double('SQS::message', body: File.read(path), receipt_handle: '123') }
    let(:messages) { [message, message] }
    let(:delete_result) { double('SQS::delete_message_batch result', length: 0) }
    before do
      allow(Aws::SQS::Client).to receive(:new) { sqs }
      allow(sqs).to receive(:receive_message) { result }
      allow(result).to receive(:messages) { messages }
      expect(sqs).to receive(:delete_message_batch) { delete_result }
    end
    it do
      expect(Out::Generation).to receive(:run) do |points, _from, _to, _source|
        expect(points).to include(hash_including(production_type: 'hydro', value: 2_755_747.5599999996,
                                                 country: 'BR-NE'))
      end

      subject.refresh
    end

    context 'with an updated duplicate' do
      let(:updated_body) do
        json = JSON.parse(File.read(path))
        json['sudesteECentroOeste']['cargaVerificada'] = 123
        JSON.generate(json)
      end
      let(:updated_message) do
        double('SQS::message', body: updated_body, receipt_handle: '124')
      end
      let(:messages) { [message, updated_message] }

      it 'keeps the later value without emitting duplicate datapoints' do
        expect(Out::Generation).to receive(:run) do |points, _from, _to, _source|
          keys = points.map { |p| [p[:time], p[:country], p[:production_type]] }
          expect(keys.uniq.length).to eq(keys.length)
        end
        expect(Out::Load).to receive(:run) do |points, _from, _to, _source|
          expect(points).to include(hash_including(country: 'BR-CS', value: 123_000.0))
          expect(points.count { |p| p[:country] == 'BR-CS' }).to eq(1)
        end
        expect(Out::Transmission).to receive(:run)

        subject.refresh
      end
    end
  end

  describe :add_json do
    let(:json) { JSON.parse(File.read('spec/fixtures/ons.json')) }

    it 'keeps negative generation but skips unrealistic values' do
      json['sul']['geracao']['hidraulica'] = -1000
      json['sul']['geracao']['total'] = -1
      json['sul']['cargaVerificada'] = -1000
      json['nordeste']['geracao']['eolica'] = -10_003
      json['nordeste']['cargaVerificada'] = -10_000

      ons = subject.new
      ons.add_json(json)

      expect(Out::Generation).to receive(:run) do |points, _from, _to, _source|
        expect(points).to include(hash_including(country: 'BR-S', production_type: 'hydro', value: -1_000_000))
        expect(points).not_to include(hash_including(country: 'BR-NE', production_type: 'wind'))
        expect(points).to include(hash_including(country: 'BR-NE', production_type: 'hydro'))
      end
      expect(Out::Load).to receive(:run) do |points, _from, _to, _source|
        expect(points).to include(hash_including(country: 'BR-S', value: -1_000_000))
        expect(points).not_to include(hash_including(country: 'BR-NE'))
      end
      expect(Out::Transmission).to receive(:run)

      ons.done!
    end
  end
end
