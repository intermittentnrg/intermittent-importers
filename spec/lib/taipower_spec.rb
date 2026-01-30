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
    let(:sqs) { double('SQS') }
    let(:result) { double('SQS::result') }
    let(:message) { double('SQS::message', body: File.read(path), receipt_handle: '123') }
    # test duplicate messages
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
        expect(points.length).to eq(10)
        expect(points).to include(hash_including(production_type: :fossil_coal, value: 6069400, country: 'TW'))
        expect(source).to eq('taipower')
      end

      subject.refresh
    end
  end
end


