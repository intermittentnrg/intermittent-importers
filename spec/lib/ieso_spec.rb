require 'rails_helper'

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
        expect(Out::Load).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(1)
          expect(points.first[:country]).to eq('CA-ON')
          expect(points.first[:value]).to eq(15130000)
          expect(source).to eq('ieso')
        end
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              path: 'PUB_Demand_2023.csv',
              source: 'ieso',
              updated_at: Time.strptime('Mon, 08 Feb 2023 13:36:56 GMT', Ieso::Base::HTTP_DATE_FORMAT)
            )
          ),
          unique_by: [:source, :path]
        )
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
        expect(Out::Unit).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(24)
          expect(points.first[:value]).to eq(4000)
          expect(source).to eq('ieso')
        end
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              path: 'PUB_GenOutputCapabilityMonth_202310.csv',
              source: 'ieso',
              updated_at: Time.strptime('Mon, 08 Feb 2023 13:36:56 GMT', Ieso::Base::HTTP_DATE_FORMAT)
            )
          ),
          unique_by: [:source, :path]
        )
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
  let(:body) { File.read('spec/fixtures/ieso_generation_month.xml') }
  context :cli do
    context 'with date' do
      it do
        stub_request(:get, 'https://reports-public.ieso.ca/public/GenOutputbyFuelHourly/PUB_GenOutputbyFuelHourly_2023.xml').
        to_return(body:, headers: {'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT'})
        expect(Out::Generation).to receive(:run) do |points, from, to, source|
          expect(points.length).to eq(8)
          expect(points.first[:country]).to eq('CA-ON')
          expect(points.first[:production_type]).to eq('nuclear')
          expect(points.first[:value]).to eq(9977000.0)
          expect(source).to eq('ieso')
        end
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              path: 'PUB_GenOutputbyFuelHourly_2023.xml',
              source: 'ieso',
              updated_at: Time.strptime('Mon, 08 Feb 2023 13:36:56 GMT', Ieso::Base::HTTP_DATE_FORMAT)
            )
          ),
          unique_by: [:source, :path]
        )
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
  context 'cli' do
    it 'processes year data' do
      expect(Out::Price).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(6264)
        expect(points.first[:value]).to eq(1442)
        expect(source).to eq('ieso')
      end
      expect(DataFile).to receive(:upsert_all).with(
        array_including(
          hash_including(
            path: match(/PUB_PriceHOEPPredispOR_\d{4}.csv/),
            source: 'ieso'
          )
        ),
        unique_by: [:source, :path]
      )
      subject.cli([date.to_s])
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

      expect(DataFile).to receive(:upsert_all).with(
        array_including(
          hash_including(
            path: match(/PUB_IntertieScheduleFlow_\d{8}\.xml/),
            source: 'ieso'
          )
        ),
        unique_by: [:source, :path]
      )

      subject.cli(['2025-09-30'])
    end
  end
end

RSpec.describe Ieso::IntertieYear do
  subject { Ieso::IntertieYear }

  let(:csv_body) do
    <<-CSV
\\Yearly Intertie Schedule and Flow Report,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
\\Created at 2026-01-01 08:01:44,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
\\For 2025,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,MANITOBA,MANITOBA,MANITOBA,MANITOBA SK,MANITOBA SK,MANITOBA SK,MICHIGAN,MICHIGAN,MICHIGAN,MINNESOTA,MINNESOTA,MINNESOTA,NEW-YORK,NEW-YORK,NEW-YORK,PQ.AT,PQ.AT,PQ.AT,PQ.B5D.B31L,PQ.B5D.B31L,PQ.B5D.B31L,PQ.D4Z,PQ.D4Z,PQ.D4Z,PQ.D5A,PQ.D5A,PQ.D5A,PQ.H4Z,PQ.H4Z,PQ.H4Z,PQ.H9A,PQ.H9A,PQ.H9A,PQ.P33C,PQ.P33C,PQ.P33C,PQ.Q4C,PQ.Q4C,PQ.Q4C,PQ.X2Y,PQ.X2Y,PQ.X2Y,Total,Total,Total
Date,Hour,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow,Imp,Exp,Flow
2025-01-01,1,85,0,-86,0,0,20,0,712,544,0,50,44,0,1600,1698,9,1131,1121,0,0,348,0,0,2,0,0,0,0,9,16,0,0,0,0,0,1,0,0,135,0,0,0,94,3502,3843
2025-01-01,2,85,0,-88,0,0,19,0,902,711,0,24,21,0,1600,1733,9,1239,1232,0,0,348,0,0,2,0,0,0,0,9,12,0,0,0,0,0,1,0,0,136,0,0,0,94,3774,4127
2025-01-01,3,85,41,-44,0,0,19,0,1194,1043,0,46,42,0,1600,1683,9,1239,1234,0,0,349,0,0,2,0,0,0,0,9,11,0,0,0,0,0,1,0,0,136,0,0,0,94,4129,4476
    CSV
  end

  context '#cli end-to-end test' do
    it 'should process date range and call Out::Transmission.run with correct data structure' do
      # Stub the HTTP request
      stub_request(:get, 'https://reports-public.ieso.ca/public/IntertieScheduleFlowYear/PUB_IntertieScheduleFlowYear_2025.csv')
        .to_return(
          body: csv_body,
          headers: {
            'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT',
            'Content-Type' => 'text/csv'
          }
        )

      # Expect Out::Transmission.run to be called with the processed data
      expect(Out::Transmission).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(12)
        expect(points.first[:from_area]).to eq('CA-ON')
        expect(points.first[:to_area]).to eq('CA-MB')
        expect(source).to eq('ieso')
      end

      expect(DataFile).to receive(:upsert_all).with(
        array_including(
          hash_including(
            path: 'PUB_IntertieScheduleFlowYear_2025.csv',
            source: 'ieso',
            updated_at: Time.strptime('Mon, 08 Feb 2023 13:36:56 GMT', Ieso::Base::HTTP_DATE_FORMAT)
          )
        ),
        unique_by: [:source, :path]
      )

      subject.cli(['2025-01-01'])
    end
  end
end

RSpec.describe Ieso::Unit do
  subject { Ieso::Unit }

  around(:example) { |ex| VCR.use_cassette('ieso_unit', &ex) }

  context 'add_date' do
    it 'processes date and calls DataFile.upsert_all with correct parameters' do
      # Expect DataFile.upsert to be called with correct parameters
      expect(DataFile).to receive(:upsert_all).with(
        array_including(
          hash_including(
            path: 'PUB_GenOutputCapability_20230901.xml',
            source: 'ieso',
            updated_at: Time.strptime('Sat, 02 Sep 2023 05:17:16 GMT', Ieso::Base::HTTP_DATE_FORMAT)
          )
        ),
        unique_by: [:source, :path]
      )

      date = Date.new(2023, 9, 1)
      subject.new.add_date(date).done!
    end
  end
end

# Note: Ieso::Load and Ieso::Price tests are not implemented because:
# - Ieso::Load uses RealtimeConstTotals CSV files which may not be available
# - Ieso::Price (HOEP) source is no longer receiving data
# When these data sources become available, tests should follow the same pattern as Ieso::Unit
