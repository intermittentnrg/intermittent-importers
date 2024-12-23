require './spec/spec_helper'

RSpec.describe EntsoeCsv::GenerationCSV do
  describe 'zip' do
    subject(:e) do
      EntsoeCsv::GenerationCSV.new('2023_09_ActualGenerationOutputPerGenerationUnit_16.1.A.zip')
    end
    before do
      expect(File).to receive(:mtime) { nil }

      zip_file = double('zip_file')
      expect(Zip::File).to receive(:open) { zip_file }
      expect(zip_file).to receive(:first) { zip_file }
      expect(zip_file).to receive(:get_input_stream) { zip_file }
      expect(zip_file).to receive(:gets).and_return("\n", nil)

      expect(DataFile).to receive(:upsert)
    end
    it { e.process }
  end
end

RSpec.describe EntsoeCsv::UnitCSV do
  subject { EntsoeCsv::UnitCSV }
  let(:body) do
    <<-CSV
DateTime (UTC)	ResolutionCode	AreaCode	AreaDisplayName	AreaTypeCode	MapCode	GenerationUnitCode	GenerationUnitName	GenerationUnitType	ActualGenerationOutput(MW)	ActualConsumption(MW)	GenerationUnitInstalledCapacity(MW)	UpdateTime(UTC)
2024-07-01 00:00:00.000	PT60M	10YAT-APG------L	Austria (AT)	BZN/CTA	AT	14W-TZH-TU-----N	Häusling	Hydro Pumped Storage	0.00		400.00	2024-07-06 00:16:32.032
2024-07-01 01:00:00.000	PT60M	10YAT-APG------L	Austria (AT)	BZN/CTA	AT	14W-TZH-TU-----N	Häusling	Hydro Pumped Storage	0.00		400.00	2024-07-06 01:16:34.034
2024-07-01 02:00:00.000	PT60M	10YAT-APG------L	Austria (AT)	BZN/CTA	AT	14W-TZH-TU-----N	Häusling	Hydro Pumped Storage	0.00		4000.00	2024-07-06 02:16:50.050
CSV
  end
  it "deduplicates capacity data" do
    expect(GenerationUnit).to receive(:upsert_all)
    expect(GenerationUnitCapacity).to receive(:upsert_all).with([
                                                                  {unit_id: 544, time: Time.parse('2024-07-01 00:00:00'), value:400000},
                                                                  {unit_id: 544, time: Time.parse('2024-07-01 02:00:00'), value:4000000}
                                                                ])
    subject.new(StringIO.new(body), '2024_07_ActualGenerationOutputPerGenerationUnit_16.1.A_r2.1.csv', Time.new(2024,7,2)).process
  end
end

RSpec.describe EntsoeCsv::LoadCSV do
  subject { EntsoeCsv::LoadCSV }
  let(:body) do
    <<-CSV
DateTime	ResolutionCode	AreaCode	AreaTypeCode	AreaName	MapCode	TotalLoadValue	UpdateTime
2024-05-22 01:00:00.000	PT15M	10Y1001A1001A83F	CTY	DE CTY	DE	41454.89	2024-05-23 02:01:28.028
    CSV
  end
  it do
    expect(Load).to receive(:upsert_all)
    subject.new(StringIO.new(body), '2024_05_ActualTotalLoad_6.1.A.csv', Time.new(2024,5,2)).process
  end
end

RSpec.describe EntsoeCsv::PriceCSV do
  subject { EntsoeCsv::PriceCSV }
  let(:body) do
    <<-CSV
InstanceCode    DateTime(UTC)   ResolutionCode  AreaCode        AreaDisplayName AreaTypeCode    MapCode ContractType    Sequence        Price[Currency/MWh]     Currency        UpdateTime(UTC)
c1058421508e8ba08cc6a260cdcd55ad	2023-09-01 00:00:00	PT60M	10Y1001A1001A82H	DE-LU	BZN	DE_LU	Day-ahead	1	93.29	EUR	2023-08-31 13:26:14
CSV
  end
  describe '#points_price' do
    before do
    end
    it do
      expect(Price).to receive(:upsert_all).with(array_including(hash_including(value: 9329)))
      subject.new(StringIO.new(body), '2023_09_DayAheadPrices_12.1.D.csv', Time.new(2023,9,2)).process
    end
  end
end

RSpec.describe EntsoeCsv::CapacityCSV do
  subject { EntsoeCsv::CapacityCSV }
  let(:datafile_name) { '2023_01_InstalledGenerationCapacityAggregated_14.1.A.csv' }
  let(:body) do
    <<-CSV
DateTime	ResolutionCode	AreaCode	AreaTypeCode	AreaName	MapCode	ProductionType	AggregatedInstalledCapacity	DeletedFlag	UpdateTime
2023-01-01 00:00:00.000	P1Y	10Y1001A1001A83F	CTY	DE CTY	DE	Wind Onshore	57589.83	0	2023-08-14 15:50:20.020
CSV
  end
  describe '#points_capacities' do
    it "provides expected value" do
      expect(::Capacity).to receive(:upsert_all).with(array_including(hash_including(value: 57589830)))
      subject.new(StringIO.new(body), datafile_name, Time.new(2023,1,1)).process
    end
  end
end
