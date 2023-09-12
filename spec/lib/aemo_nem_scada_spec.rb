require './spec/spec_helper'

RSpec.describe Aemo::Scada do
  describe :cli do
    subject { Aemo::Scada.cli(args) }
    let(:body) do
      <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",WDGPH1,0
CSV
    end

    context 'with no arguments' do
      let(:args) { [] }
      it do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/Dispatch_SCADA/').
          to_return(body: '<A HREF="/123.zip"></A>')
        stub_request(:get, 'https://nemweb.com.au/123.zip')
        stub_zip_inputstream(body)

        expect(GenerationUnit).to receive(:upsert_all)
        subject
      end
    end
    context 'with file.zip' do
    end
    context 'with file.csv' do
    end
  end
end

RSpec.describe Aemo::ScadaMMS do
  describe :cli do
    subject { Aemo::ScadaMMS.cli(args) }
    let(:body) do
      <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",WDGPH1,0
CSV
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      it do
        stub_request(:get, 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2023/MMSDM_2023_01/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DISPATCH_UNIT_SCADA_202301010000.zip')
        stub_zip_inputstream(body)

        expect(GenerationUnit).to receive(:upsert_all)
        subject
      end
    end
  end
end
