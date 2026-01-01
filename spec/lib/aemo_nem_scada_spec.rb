require './spec/spec_helper'

def test_calculate_range
  context 'has range' do
    it "calculates from and to range" do
      expect(Out::Unit).to receive(:run).with(anything, Time.new(2022, 12, 31, 14, 0), Time.new(2022, 12, 31, 14, 5), 'aemo')
      subject.cli(args)
    end
    it "calls GenerationUnit.aggregate_to_generation with correct args" do
      expect(GenerationUnit).to receive(:aggregate_to_generation).with(Time.new(2022, 12, 31, 14, 0), Time.new(2022, 12, 31, 14, 5), anything)
      subject.cli(args)
    end
  end
end

RSpec.describe AemoNem::Scada do
  subject { AemoNem::Scada }
  before { AemoNem::Scada.clear_cache! }

  context 'with negative generation' do
    let(:datafile_name) { 'PUBLIC_DISPATCHSCADA_202301010000_0000000397026531.CSV' }
    context 'pumped hydro' do
      let(:body) do
        <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",SNOWYP,0.80
CSV
      end
      it "has negative generation" do
        expect(GenerationUnit).to receive(:upsert_all).with array_including(hash_including(value: -800))
        subject.new.add_buffer(body, datafile_name, Time.now).done!
      end
    end
    context 'battery_charging' do
      let(:body) do
        <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",HPRL1,0.80
CSV
      end
      it "has negative generation" do
        expect(GenerationUnit).to receive(:upsert_all).with array_including(hash_including(value: -800))
        subject.new.add_buffer(body, datafile_name, Time.now).done!
      end
    end
  end
  describe :cli do
    let(:body) do
      <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/01/01 00:00:00",WDGPH1,0
CSV
    end
    let(:datafile_name) { 'PUBLIC_DISPATCHSCADA_202301010000_0000000397026531.zip' }

    context 'with no arguments' do
      let(:args) { [] }
      let(:index_body) do
        <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
        HTML
      end
      let(:mtime) { Zip::DOSTime.new(2025,12,10,9,6,43) }
      let(:zip_body) { create_zip_file(body, 'PUBLIC_DISPATCHSCADA_202301010000_0000000397026531.csv', mtime) }

      before do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/Dispatch_SCADA/').
          to_return(body: index_body)
        stub_request(:get, "https://nemweb.com.au/#{datafile_name}").
          to_return(body: zip_body.string, headers: {last_modified: "Wed, 10 Dec 2025 09:06:43 GMT"})
      end

      it do
        expect(GenerationUnit).to receive(:upsert_all)
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              source: 'aemo',
              updated_at: Time.strptime('Wed, 10 Dec 2025 09:06:43 GMT', '%a, %d %b %Y %H:%M:%S GMT')
            )
          ),
          unique_by: [:source, :path]
        )
        subject.cli(args)
      end

      it "to aggregate to generation" do
        Generation.uncached do
          expect {
            subject.cli(args)
          }.to change { Generation.count }.by(1)
        end
      end
      test_calculate_range
    end

    context 'with filename.zip' do
    end

    context 'with filename.csv' do
      let(:datafile_name) { 'PUBLIC_DISPATCHSCADA_202301010000_0000000397026531.csv' }
      let(:args) { [datafile_name] }
      before do
        allow(File).to receive(:open) { double('File', read: body, mtime: Time.now) }
      end
      it do
        expect(GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
      test_calculate_range
    end

    context 'with invalid filename.csv' do
      let(:args) { ['xyz.csv'] }
      it "raises ArgumentError" do
        allow(File).to receive(:open)
        expect {
          subject.cli(args)
        }.to raise_error(ArgumentError)
      end
    end

    # doesn't support date range
  end
end
