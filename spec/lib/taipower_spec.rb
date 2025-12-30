require 'spec_helper'

RSpec.describe Taipower::Generation do
  subject { Taipower::Generation }
  let :path do
    'spec/fixtures/taipower.json'
  end

  before(:each) do
    Out::Unit.class_variable_set(:@@units, {})
  end

  describe :cli do
    it do
      expect(Out::Generation).to receive(:run).with(array_including(hash_including(production_type: :hydro)), anything, anything, 'taipower')
      subject.cli([path])
    end
  end

  describe :refresh do
    it do
      expect(Out::Generation).to receive(:run).with(array_including(hash_including(production_type: :hydro)), anything, anything, 'taipower')

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
