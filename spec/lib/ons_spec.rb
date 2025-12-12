require 'spec_helper'

RSpec.describe Ons do
  subject { Ons }
  let :path do
    'spec/fixtures/ons.json'
  end

  describe :cli do
    it do
      expect(Out2::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro')), anything, anything, 'ons')
      subject.cli([path])
    end
  end

  describe :refresh do
    it do
      expect(Out2::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro')), anything, anything, 'ons')

      sqs = double('SQS')
      result = double('SQS::result')
      message = double('SQS::message', body: File.read(path), receipt_handle: '123')
      messages = [message]
      expect(Aws::SQS::Client).to receive(:new) { sqs }
      expect(sqs).to receive(:receive_message) { result }
      expect(result).to receive(:messages).at_least(:once) { messages }
      expect(sqs).to receive(:delete_message_batch) { double('SQS::delete_message_batch result', length: 0) }

      subject.refresh
    end
  end
end
