require 'spec_helper'

RSpec.describe Aeso::Generation do
  subject { Aeso::Generation }
  let :path do
    'spec/fixtures/aeso-csdreport.csv'
  end

  describe :cli do
    it do
      expect(Out2::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro', value: 118000)), anything, anything, 'aeso')
      subject.cli([path])
    end
  end

  describe :refresh do
    it do
      expect(Out2::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro', value: 118000)), anything, anything, 'aeso')

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

RSpec.describe Aeso::Price do
  describe :cli do
    it 'processes price data end-to-end', :vcr do
      VCR.use_cassette('aeso_price_2023_09') do
        expect(Out::Price).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(48)
          expect(points.first[:country]).to eq('CA-AB')
          expect(source).to eq('aeso')
        end

        Aeso::Price.cli(['2023-09-01', '2023-09-02'])
      end
    end
  end
end
