require 'spec_helper'

RSpec.describe Aeso::Generation do
  subject { Aeso::Generation }
  let :path do
    'spec/fixtures/aeso-csdreport.csv'
  end

  describe :cli do
    it do
      expect(Out::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro', value: 118000)), anything, anything, 'aeso')
      subject.cli([path])
    end
  end

  describe :refresh do
    it do
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points).to include(hash_including(production_type: 'hydro', value: 118000))
        expect(source).to eq 'aeso'
      end

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

RSpec.describe Aeso::GenerationHistory do
  subject { Aeso::GenerationHistory }

  let :csv_content do
    <<-CSV
Date (MST),Date (MPT),Asset Short Name,Asset Name,Asset Grouping,Volume,Maximum Capability,System Capability,Fuel Type,Sub Fuel Type,Planning Area,Region\r
2025-06-30 23:00:00,2025-07-01 00:00:00,ACD1,ACD1 Big Sky Solar,ACD1,10.5,140.0,140.0,SOLAR,SOLAR,48,South\r
    CSV
  end

  let(:zip_file_path) { 'test-generation-history.zip' }
  let(:zip_data) { create_zip_file(csv_content, 'generation-history.csv') }

  describe :cli do
    it 'processes generation history data from zip' do
      allow(Zip::InputStream).to receive(:open).with(zip_file_path).and_yield(
        Zip::InputStream.new(zip_data)
      )

      expect(Out::Unit).to receive(:run).with(
        [{country: 'CA-AB', production_type: 'solar', time: kind_of(Time), unit: 'ACD1', value: 10500}],
        kind_of(Time),
        kind_of(Time),
        'aeso'
      )

      expect(Out::UnitCapacity).to receive(:run).with(
        [{country: 'CA-AB', production_type: 'solar', time: kind_of(Time), unit: 'ACD1', value: 140000}],
        kind_of(Time),
        kind_of(Time),
        'aeso'
      )

      subject.cli([zip_file_path])
    end
  end
end
