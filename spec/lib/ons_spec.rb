require 'spec_helper'

RSpec.describe Ons do
  subject { Ons }
  let :path do
    'spec/fixtures/ons.json'
  end

  describe :cli do
    it do
      expect(Out::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro')), anything, anything, 'ons')
      subject.cli([path])
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
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points).to include(hash_including(production_type: 'hydro', value: 2755747.5599999996, country: 'BR-NE'))
      end

      subject.refresh
    end
  end
end
