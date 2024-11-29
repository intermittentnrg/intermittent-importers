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
2023-10-01,ABKENORA,HYDRO,Output,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,
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
  context '#points_price' do
    it do
      prices = subject.new(date).points_price
      expect(prices.first).to include(value: 1442)
    end
  end
end

RSpec.describe Ieso::Intertie do
  subject { Ieso::Intertie }
end

RSpec.describe Ieso::IntertieYear do
  subject { Ieso::IntertieYear }
end
