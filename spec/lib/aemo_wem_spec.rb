require './spec/spec_helper'

RSpec.describe AemoWem::Scada do
  describe :cli do
    subject { AemoWem::Scada }
    let(:body) do
        <<-CSV
Trading Date,Interval Number,Trading Interval,Participant Code,Facility Code,Energy Generated (MWh),EOI Quantity (MW),Extracted At
"2018-10-01",1,2018-10-01 08:00:00,"WPGENER","ALBANY_WF1",3.021,7.159,"2018-11-02 23:35:00"
CSV
    end

    context 'without argument' do
      let(:args) { [] }
      let(:index_url) { 'https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/' }
      let(:data_file) { 'abc.csv' }
      it do
        stub_request(:get, index_url).
          to_return(body: "<A HREF=\"/#{data_file}\"></A>")
        stub_request(:get, "https://data.wa.aemo.com.au/#{data_file}").
          to_return(body:)

        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    context 'with filename.csv' do
      let(:args) { ['path/to/file.csv'] }
      it do
        expect(File).to receive(:open) { StringIO.new(body) }
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/facility-scada-2023-01.csv').
          to_return(body:)
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    #it { require 'pry' ; binding.pry }
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
          to_return(body: '<A HREF="/abc.csv"></A>')
        stub_request(:get, 'https://data.wa.aemo.com.au/abc.csv').
          to_return(body:)

        expect(Price).to receive(:upsert_all)
        expect(Load).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    context 'with filename.csv' do
      let(:args) { ['path/to/file.csv'] }
      it
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] } #FIXME yearly
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
