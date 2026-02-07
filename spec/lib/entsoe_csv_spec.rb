# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe EntsoeCsv::Generation do
  subject { EntsoeCsv::Generation.new }
  describe 'zip' do
    let(:body) do
      <<-CSV
DateTime(UTC)	ResolutionCode	AreaCode	AreaDisplayName	AreaTypeCode	AreaMapCode	ProductionType	ActualGenerationOutput[MW]	ActualConsumption[MW]	UpdateTime(UTC)
2023-09-01 00:00:00	PT15M	10YAT-APG------L	Austria (AT)	BZN/CTA/CTY	AT	Biomass	120.0	0.0	2025-10-12 15:41:35
2023-09-01 00:15:00	PT15M	10YAT-APG------L	Austria (AT)	BZN/CTA/CTY	AT	Biomass	120.0	0.0	2025-10-12 15:41:35
      CSV
    end

    it do
      expect(Out::Generation).to receive(:run) do |data, from, to, source_id|
        expect(data.length).to eq(2)
        expect(from).to be_a(Date)
        expect(to).to be_a(Date)
        expect(source_id).to eq('entsoe')
      end

      expect(DataFile).to receive(:upsert_all).with(
        [hash_including(
          path: '2023_09_ActualGenerationOutputPerGenerationUnit_16.1.A.zip',
          source: 'entsoe'
        )],
        unique_by: %i[source path]
      )
      subject.add_buffer(body, '2023_09_ActualGenerationOutputPerGenerationUnit_16.1.A.zip', Time.new(2023, 9, 1)).done!
    end
  end
end

RSpec.describe EntsoeCsv::Unit do
  subject { EntsoeCsv::Unit }
  let(:body) do
    <<-CSV
DateTime(UTC)	ResolutionCode	AreaCode	AreaDisplayName	AreaTypeCode	AreaMapCode	GenerationUnitCode	GenerationUnitName	GenerationUnitType	ActualGenerationOutput[MW]	ActualConsumption[MW]	UpdateTime(UTC)
2024-07-01 00:00:00	PT60M	10YAT-APG------L	Austria (AT)	BZN/CTA	AT	14W-TZH-TU-----N	Häusling	Hydro Pumped Storage	0.0		2025-09-24 11:57:39
2024-07-01 01:00:00	PT60M	10YAT-APG------L	Austria (AT)	BZN/CTA	AT	14W-TZH-TU-----N	Häusling	Hydro Pumped Storage	0.0		2025-09-24 11:57:39
2024-07-01 02:00:00	PT60M	10YAT-APG------L	Austria (AT)	BZN/CTA	AT	14W-TZH-TU-----N	Häusling	Hydro Pumped Storage	0.0		2025-09-24 11:57:39
    CSV
  end
  it 'deduplicates capacity data' do
    expect(GenerationUnit).to receive(:upsert_all)
    expect(DataFile).to receive(:upsert_all).with(
      [hash_including(
        path: '2024_07_ActualGenerationOutputPerGenerationUnit_16.1.A_r2.1.csv',
        source: 'entsoe'
      )],
      unique_by: %i[source path]
    )
    subject.new.add_buffer(body, '2024_07_ActualGenerationOutputPerGenerationUnit_16.1.A_r2.1.csv',
                           Time.new(2024, 7, 2)).done!
  end
end

RSpec.describe EntsoeCsv::Load do
  subject { EntsoeCsv::Load }
  let(:body) do
    <<-CSV
DateTime	ResolutionCode	AreaCode	AreaTypeCode	AreaName	MapCode	TotalLoadValue	UpdateTime
2024-05-22 01:00:00.000	PT15M	10Y1001A1001A83F	CTY	DE CTY	DE	41454.89	2024-05-23 02:01:28.028
    CSV
  end
  it do
    expect(Load).to receive(:upsert_all)
    expect(DataFile).to receive(:upsert_all).with(
      [hash_including(
        path: '2024_05_ActualTotalLoad_6.1.A.csv',
        source: 'entsoe'
      )],
      unique_by: %i[source path]
    )
    subject.new.add_buffer(body, '2024_05_ActualTotalLoad_6.1.A.csv', Time.new(2024, 5, 2)).done!
  end
end

RSpec.describe EntsoeCsv::Price do
  subject { EntsoeCsv::Price }
  let(:body) do
    <<-CSV
InstanceCode	DateTime(UTC)	ResolutionCode	AreaCode	AreaDisplayName	AreaTypeCode	MapCode	ContractType	Sequence	Price[Currency/MWh]	Currency	UpdateTime(UTC)
2ede04b15f2b8c907fb1e2fba9de7527	2023-09-01 00:00:00	PT60M	10Y1001A1001A82H	DE-LU	BZN	DE_LU	Day-ahead	1	93.29	EUR	2024-10-07 06:23:24
    CSV
  end
  describe '#points_price' do
    before do
    end
    it do
      expect(Price).to receive(:upsert_all).with(array_including(hash_including(value: 9329)))
      expect(DataFile).to receive(:upsert_all).with(
        [hash_including(
          path: '2023_09_EnergyPrices_12.1.D_r3.csv',
          source: 'entsoe'
        )],
        unique_by: %i[source path]
      )
      subject.new.add_buffer(body, '2023_09_EnergyPrices_12.1.D_r3.csv', Time.new(2023, 9, 2)).done!
    end
  end
end

RSpec.describe EntsoeCsv::Transmission do
  subject { EntsoeCsv::Transmission }
  let(:body) do
    <<-CSV
DateTime(UTC)	ResolutionCode	OutAreaCode	OutAreaDisplayName	OutAreaTypeCode	OutAreaMapCode	InAreaCode	InAreaDisplayName	InAreaTypeCode	InAreaMapCode	Flow[MW]	UpdateTime(UTC)
2023-09-01 00:00:00	PT60M	10YFR-RTE------C	France (FR)	BZN	FR	10YBE----------2	Belgium (BE)	BZN	BE	1234.56	2023-09-01 01:00:00
    CSV
  end
  it 'parses transmission data' do
    expect(Transmission).to receive(:upsert_all)
    expect(DataFile).to receive(:upsert_all).with(
      [hash_including(
        path: '2023_09_PhysicalFlows_12.1.G.csv',
        source: 'entsoe'
      )],
      unique_by: %i[source path]
    )
    subject.new.add_buffer(body, '2023_09_PhysicalFlows_12.1.G.csv', Time.new(2023, 9, 1)).done!
  end
end

RSpec.describe EntsoeCsv::UnitCapacity do
  subject { EntsoeCsv::UnitCapacity }
end
