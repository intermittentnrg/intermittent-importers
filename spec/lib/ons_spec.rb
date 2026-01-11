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
  end
end
