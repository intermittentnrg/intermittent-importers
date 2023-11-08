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

RSpec.describe EntsoeCsv::PriceCSV do
  subject { EntsoeCsv::PriceCSV }
  let(:body) do
    <<-CSV
DateTime	ResolutionCode	AreaCode	AreaTypeCode	AreaName	MapCode	Price	Currency	UpdateTime
2023-09-01 00:00:00.000	PT60M	10Y1001A1001A82H	BZN	DE-LU BZN	DE_LU	93.29	EUR	2023-08-31 13:26:14.014
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
