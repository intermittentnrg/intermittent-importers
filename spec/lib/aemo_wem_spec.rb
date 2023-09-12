require './spec/spec_helper'

RSpec.describe AemoWem::ScadaWem do
  describe :cli do
    subject { AemoWem::ScadaWem.cli(args) }
    let(:body) do
        <<-CSV
Trading Date,Interval Number,Trading Interval,Participant Code,Facility Code,Energy Generated (MWh),EOI Quantity (MW),Extracted At
"2018-10-01",1,2018-10-01 08:00:00,"WPGENER","ALBANY_WF1",3.021,7.159,"2018-11-02 23:35:00"
CSV
    end
    context 'without argument' do
      let(:args) { [] }

      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/').
          to_return(body: '<A HREF="/abc.csv"></A>')
        stub_request(:get, 'https://data.wa.aemo.com.au/abc.csv').
          to_return(body:)

        expect(GenerationUnit).to receive(:upsert_all)
        subject
      end
    end

    context 'with filename.csv' do
      let(:args) { ['path/to/file.csv'] }
      it
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      it do
        stub_request(:get, 'https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/facility-scada-2023-01.csv').
          to_return(body:)
        expect(GenerationUnit).to receive(:upsert_all)
        subject
      end
    end

    #it { require 'pry' ; binding.pry }
  end
end
