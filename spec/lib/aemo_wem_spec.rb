require './spec/spec_helper'

def test_calculates_range
  context 'has range' do
    it "calculates from and to range" do
      expect(Out2::Unit).to receive(:run).with(anything, Time.new(2022, 12, 31, 16, 0), Time.new(2023, 1, 31, 16, 0), 'aemo')
      subject.cli(args)
    end
    it "calls GenerationUnit.aggregate_to_generation with correct args" do
      expect(GenerationUnit).to receive(:aggregate_to_generation).with(/'2022-12-31 16:00.*'2023-01-31 16:00/)
      subject.cli(args)
    end
  end
end

RSpec.describe AemoWem::Scada do
  subject { AemoWem::Scada }
  let(:index_url) { 'https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/' }
  let(:datafile_name) { 'facility-scada-2023-01.csv' }
  let(:index_body) do
    <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> 1/23/2023 11:09 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
    HTML
  end
  describe :cli do
    let(:body) do
        <<-CSV
Trading Date,Interval Number,Trading Interval,Participant Code,Facility Code,Energy Generated (MWh),EOI Quantity (MW),Extracted At
"2023-01-01",1,2023-01-01 08:00:00,"WPGENER","ALBANY_WF1",3.021,7.159,"2023-01-02 23:35:00"
CSV
    end

    context 'without argument' do
      let(:args) { [] }

      before do
        stub_request(:get, index_url).
          to_return(body: index_body)
        stub_request(:get, "https://data.wa.aemo.com.au/#{datafile_name}").
          to_return(body:)
      end

      it do
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end

      it "to aggregate to generation" do
        Generation.uncached do
          expect {
            subject.cli(args)
          }.to change { Generation.count }.by(1)
        end
      end

      test_calculates_range
    end

    context 'with facility-scada-yyyy-mm.csv' do
      let(:args) { ['xyz/facility-scada-2023-01.csv'] }
      before do
        expect(File).to receive(:open) { StringIO.new(body) }
      end
      it do
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end

      test_calculates_range
    end

    context 'with invalid filename.csv' do
      let(:args) { ['xyz.csv'] }
      it "raises ArgumentError" do
        expect {
          subject.cli(args)
        }.to raise_error(ArgumentError)
      end
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      before do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/facility-scada-2023-01.csv').
          to_return(body:)
      end
      it do
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end

      test_calculates_range
    end

    #it { require 'pry' ; binding.pry }
  end

  describe :each do
    let(:datafile_url) { "#{subject::URL_BASE}/#{datafile_name}" }

    before do
      stub_request(:get, index_url).
        to_return(body: index_body)
      stub_request(:get, datafile_url)

      index_datafile_time = Time.new(2023,1,23,11,9) - 10.hours
      datafile = double('DataFile')
      expect(datafile).to receive(:exists?) { datafile_exists }
      expect(DataFile).to receive(:where).with(hash_including(updated_at: index_datafile_time...Float::INFINITY)) { datafile }
    end

    context 'when file old' do
      let(:datafile_exists) { true }
      it "ignores old file" do
        subject.each {}
        expect(WebMock).not_to have_requested(:get, datafile_url)
      end
    end

    context 'when file is newer' do
      let(:datafile_exists) { false }
      it "fetches updated file" do
        subject.each {}
        expect(WebMock).to have_requested(:get, datafile_url)
      end
    end
  end
end

RSpec.xdescribe AemoWem::ScadaLive do
  describe :cli do
    subject { AemoWem::ScadaLive }
    let(:body) do
        <<-CSV
PERIOD,PARTICIPANT_CODE,FACILITY_CODE,ACTUAL_MW,PCT_ALT_FUEL,PEAK_MW,OUTAGE_MW,PEAK_OUTAGE_MW,POTENTIAL_MWH,INTERVALS_GENERATING,TOTAL_INTERVALS,PCT_GENERATING,AS_AT
2023-09-12 02:00:00,"ALBGRAS","ALBANY_WF1",5.62,0,5.62,,,2.7725,1,1,1,"2023-09-14 02:00:00"
CSV
    end

    context 'without argument' do
      it do
        stub_request(:get, 'https://aemo.com.au/aemo/data/wa/infographic/facility-intervals-last96.csv').
          to_return(body:)
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli([])
      end
    end
  end
end



RSpec.describe AemoWem::Balancing do
  let(:datafile_name) { 'abc.csv' }
  let(:index_body) do
    <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> 1/23/2023 11:09 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
    HTML
  end

  describe :cli do
    subject { AemoWem::Balancing }

    let(:body) do
      <<-CSV
Trading Date,Interval Number,Trading Interval,Load Forecast (MW),Forecast As At,Scheduled Generation (MW),Non-Scheduled Generation (MW),Total Generation (MW),Final Price ($/MWh),Extracted At
"2023-01-01",1,2023-01-01 08:00:00,998.59,2023-01-01 07:23:08,756.291,292.584,1048.875,-72.19,"2023-09-12 23:30:16"
CSV
    end

    context 'without argument' do
      let(:args) { [] }

      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/datafiles/balancing-summary/').
          to_return(body: index_body)
        stub_request(:get, "https://data.wa.aemo.com.au/#{datafile_name}").
          to_return(body:)

        expect(Price).to receive(:upsert_all)
        expect(Load).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    context 'with filename.csv' do
      let(:args) { ['path/to/file.csv'] }
      before do
        expect(File).to receive(:open) { StringIO.new(body) }
      end
      it do
        expect(Price).to receive(:upsert_all)
        expect(Load).to receive(:upsert_all)
        subject.cli(args)
      end
      it do
        subject.cli(args)
      end
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2024-01-01'] }
      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/datafiles/balancing-summary/balancing-summary-2023.csv').
          to_return(body:)
        expect(Price).to receive(:upsert_all)
        expect(Load).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    #it { require 'pry' ; binding.pry }
  end
end

RSpec.xdescribe AemoWem::BalancingLive do
  describe :cli do
    subject { AemoWem::BalancingLive }
    let(:body) do
        <<-CSV
TRADING_DAY_INTERVAL,FORECAST_EOI_MW,FORECAST_MW,PRICE,FORECAST_NSG_MW,ACTUAL_NSG_MW,ACTUAL_TOTAL_GENERATION,RTD_TOTAL_GENERATION,RTD_TOTAL_SPINNING_RESERVE,LFAS_UP_REQUIREMENT_MW,TOTAL_OUTAGE_MW,PLANNED_OUTAGE_MW,FORCED_OUTAGE_MW,CONS_OUTAGE_MW,AS_AT
2023-09-12 02:00:00,1725.011,1689.752,74.39,72.703,24.85,1738.366,,,65,564.9,270.6,294.3,0,"2023-09-14 02:00:00"
CSV
    end

    context 'without argument' do
      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/infographic/neartime/pulse.csv').
          to_return(body:)
        expect(Price).to receive(:upsert_all)
        expect(Load).to receive(:upsert_all)
        subject.cli([])
      end
    end
  end
end

RSpec.describe AemoWem::DistributedPv do
  subject { AemoWem::DistributedPv }
  let(:index_body) do
    <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> 1/23/2023 11:09 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
    HTML
  end
  let(:datafile_name) { 'distributed-pv-2003.csv' }
  let(:body) do
    <<-CSV
Trading Date,Interval Number,Trading Interval,Estimated DPV Generation (MW),Extracted At
"2023-01-01",1,2023-01-01 08:00:00,874.3489,"2023-09-14 12:00:00"
    CSV
  end
  describe :cli do
    context 'without argument' do
      let(:args) { [] }
      before do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/public-data/datafiles/distributed-pv/').
          to_return(body: index_body)
        stub_request(:get, 'https://data.wa.aemo.com.au/distributed-pv-2003.csv').
          to_return(body:)
      end
      it do
        expect(Generation).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    context 'with filename.csv' do
      let(:args) { [datafile_name] }
      before do
        expect(File).to receive(:open) { StringIO.new(body) }
      end
      it do
        expect(Generation).to receive(:upsert_all)
        subject.cli(args)
      end
      it do
        subject.cli(args)
      end
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2024-01-01'] }
      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/public-data/datafiles/distributed-pv/distributed-pv-2023.csv').
          to_return(body:)
        expect(Generation).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end
end
