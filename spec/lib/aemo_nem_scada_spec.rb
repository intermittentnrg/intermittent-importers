require './spec/spec_helper'

RSpec.describe AemoNem::Scada do
  describe :cli do
    subject { AemoNem::Scada }
    let(:body) do
      <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",WDGPH1,0
CSV
    end

    context 'with no arguments' do
      let(:args) { [] }
      let(:index_body) do
        <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
        HTML
      end
      let(:datafile_name) { '123.zip' }
      before do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/Dispatch_SCADA/').
          to_return(body: index_body)
        stub_request(:get, 'https://nemweb.com.au/123.zip')
        stub_zip_inputstream(body)
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
    end

    context 'with filename.csv' do
      let(:args) { ['path/to/file.csv'] }
      it do
        allow(File).to receive(:open) { StringIO.new(body) }
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end

    context 'with file.csv' do
      it
    end
    # not implemented: with date range
  end
end

RSpec.describe AemoNem::ScadaMMS do
  describe :cli do
    subject { AemoNem::ScadaMMS }
    let(:body) do
      <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",WDGPH1,0
CSV
    end

    context 'with no arguments' do
      it #not implemented
    end

    context 'with file.zip' do
      it #not implemented
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      it do
        stub_request(:get, 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2023/MMSDM_2023_01/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DISPATCH_UNIT_SCADA_202301010000.zip')
        stub_zip_inputstream(body)

        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end
end
