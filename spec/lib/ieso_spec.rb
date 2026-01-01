require './spec/spec_helper'

RSpec.describe Ieso::LoadYear do
  subject { Ieso::LoadYear }
  let(:body) do
    <<-CSV
2023-01-01,1,15130,13514
CSV
  end
  context :cli do
    context 'with date' do
      it do
        stub_request(:get, 'https://reports-public.ieso.ca/public/Demand/PUB_Demand_2023.csv').
          to_return(body:, headers: {'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT'})
        expect(::Load).to receive(:upsert_all)
        subject.cli(['2023-10-01'])
      end
    end
  end
end

RSpec.describe Ieso::UnitMonth do
  subject { Ieso::UnitMonth }
  let(:body) do
    <<-CSV
\\Generator Output Capability Month Report,,,,,,,,,,,,,,,,,,,,,,,,,,,
\\Created at 2023-11-01 06:00:14,,,,,,,,,,,,,,,,,,,,,,,,,,,
\\For October 2023,,,,,,,,,,,,,,,,,,,,,,,,,,,
Delivery Date,Generator,Fuel Type,Measurement,Hour 1,Hour 2,Hour 3,Hour 4,Hour 5,Hour 6,Hour 7,Hour 8,Hour 9,Hour 10,Hour 11,Hour 12,Hour 13,Hour 14,Hour 15,Hour 16,Hour 17,Hour 18,Hour 19,Hour 20,Hour 21,Hour 22,Hour 23,Hour 24
2023-10-01,ABKENORA,HYDRO,Output,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,
    CSV
  end

  context :cli do
    context 'with date range'
    context 'with date' do
      it do
        stub_request(:get, 'https://reports-public.ieso.ca/public/GenOutputCapabilityMonth/PUB_GenOutputCapabilityMonth_202310.csv').
          to_return(body:, headers: {'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT'})
        expect(::GenerationUnit).to receive(:upsert_all)
        subject.cli(['2023-10-01'])
      end
    end
    context 'with file.csv'
  end
end

RSpec.describe Ieso::Unit do
  subject { Ieso::Unit }
end

RSpec.describe Ieso::GenerationMonth do
  subject { Ieso::GenerationMonth }
  let(:body) do
    # needs 2x HourlyData and 2x FuelTotal for correct hash to be produced
    <<-XML
<Document>
    <DocBody>
        <DeliveryYear>2023</DeliveryYear>
        <DailyData>
            <Day>2023-01-01</Day>
            <HourlyData>
                <Hour>1</Hour>
                <FuelTotal>
                    <Fuel>NUCLEAR</Fuel>
                    <EnergyValue>
                        <OutputQuality>0</OutputQuality>
                        <Output>9977</Output>
                    </EnergyValue>
                </FuelTotal>
                <FuelTotal>
                    <Fuel>GAS</Fuel>
                    <EnergyValue>
                        <OutputQuality>-3</OutputQuality>
                        <Output>130</Output>
                    </EnergyValue>
                </FuelTotal>
            </HourlyData>
            <HourlyData>
                <Hour>2</Hour>
                <FuelTotal>
                    <Fuel>NUCLEAR</Fuel>
                    <EnergyValue>
                        <OutputQuality>0</OutputQuality>
                        <Output>9993</Output>
                    </EnergyValue>
                </FuelTotal>
                <FuelTotal>
                    <Fuel>GAS</Fuel>
                    <EnergyValue>
                        <OutputQuality>-3</OutputQuality>
                        <Output>130</Output>
                    </EnergyValue>
                </FuelTotal>
            </HourlyData>
        </DailyData>
        <DailyData>
            <Day>2023-01-02</Day>
            <HourlyData>
                <Hour>1</Hour>
                <FuelTotal>
                    <Fuel>NUCLEAR</Fuel>
                    <EnergyValue>
                        <OutputQuality>0</OutputQuality>
                        <Output>10009</Output>
                    </EnergyValue>
                </FuelTotal>
                <FuelTotal>
                    <Fuel>GAS</Fuel>
                    <EnergyValue>
                        <OutputQuality>-3</OutputQuality>
                        <Output>131</Output>
                    </EnergyValue>
                </FuelTotal>
            </HourlyData>
            <HourlyData>
                <Hour>2</Hour>
                <FuelTotal>
                    <Fuel>NUCLEAR</Fuel>
                    <EnergyValue>
                        <OutputQuality>0</OutputQuality>
                        <Output>10016</Output>
                    </EnergyValue>
                </FuelTotal>
                <FuelTotal>
                    <Fuel>GAS</Fuel>
                    <EnergyValue>
                        <OutputQuality>-3</OutputQuality>
                        <Output>131</Output>
                    </EnergyValue>
                </FuelTotal>
            </HourlyData>
        </DailyData>
    </DocBody>
</Document>
XML
  end
  context :cli do
    context 'with date' do
      it do
        stub_request(:get, 'https://reports-public.ieso.ca/public/GenOutputbyFuelHourly/PUB_GenOutputbyFuelHourly_2023.xml').
        to_return(body:, headers: {'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT'})
        expect(Generation).to receive(:upsert_all)
        subject.cli(['2023-10-01'])
      end
    end
  end
end

RSpec.describe Ieso::Price do
  subject { Ieso::Price }
end

RSpec.describe Ieso::PriceYear do
  subject { Ieso::PriceYear }
  around(:example) { |ex| VCR.use_cassette('ieso_price_year', &ex) }
  let(:date) { Date.new(2023,1,1) }
  context '#process' do
    it do
      expect(Out::Price).to receive(:run).with(array_including(hash_including(value: 1442)), anything, anything, anything)
      subject.new(date).process
    end
  end
end

RSpec.describe Ieso::Intertie do
  subject { Ieso::Intertie }

  around(:example) { |ex| VCR.use_cassette('ieso_intertie_20250930', &ex) }

  context '#cli end-to-end test' do
    it 'should process date and call Out::Transmission.run with correct data structure' do
      # Expect Out::Transmission.run to be called with the processed data
      expect(Out::Transmission).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(1152)
        expect(points.first[:from_area]).to eq('CA-ON')
        expect(points.first[:to_area]).to eq('CA-MB')
        expect(source).to eq('ieso')
      end

      subject.cli(['2025-09-30'])
    end
  end
end

RSpec.describe Ieso::IntertieYear do
  subject { Ieso::IntertieYear }

  around(:example) { |ex| VCR.use_cassette('ieso_intertie_year_2023', &ex) }

  context '#cli end-to-end test' do
    it 'should process date range and call Out::Transmission.run with correct data structure' do
      # Expect Out::Transmission.run to be called with the processed data
      expect(Out::Transmission).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(35040)
        expect(points.first[:from_area]).to eq('CA-ON')
        expect(points.first[:to_area]).to eq('CA-MB')
        expect(source).to eq('ieso')
      end

      subject.cli(['2023-01-01', '2023-01-03'])
    end
  end
end

RSpec.describe Ieso::Unit do
  subject { Ieso::Unit }

  around(:example) { |ex| VCR.use_cassette('ieso_unit', &ex) }

  context '#process end-to-end test' do
    it 'should process file and call DataFile.upsert with correct parameters' do
      # Expect DataFile.upsert to be called with correct parameters
      expect(DataFile).to receive(:upsert).with(
        hash_including(
          path: 'PUB_GenOutputCapability_20230901.xml',
          source: 'ieso',
          updated_at: Time.strptime('Sat, 02 Sep 2023 05:17:16 GMT', Ieso::Base::HTTP_DATE_FORMAT)
        ),
        unique_by: [:source, :path]
      )

      subject.new('https://reports-public.ieso.ca/public/GenOutputCapability/PUB_GenOutputCapability_20230901.xml').process
    end
  end
end

# Note: Ieso::Load and Ieso::Price tests are not implemented because:
# - Ieso::Load uses RealtimeConstTotals CSV files which may not be available
# - Ieso::Price (HOEP) source is no longer receiving data
# When these data sources become available, tests should follow the same pattern as Ieso::Unit
