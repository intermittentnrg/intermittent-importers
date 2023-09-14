require './spec/spec_helper'

RSpec.describe AemoNem::RooftopPv do
  describe :cli do
    subject { AemoNem::RooftopPv.cli(args) }
    let(:body) do
      <<-CSV
D,ROOFTOP,ACTUAL,2,"2023/09/13 04:30:00",NSW1,0,1,MEASUREMENT,"2023/09/13 04:49:11"
CSV
    end

    context 'with no arguments' do
      let(:args) { [] }
      let(:index_body) do
        <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
        HTML
      end
      let(:datafile_name) { 'PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168830.zip' }
      it do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/').
          to_return(body: index_body)
        stub_request(:get, "https://nemweb.com.au/#{datafile_name}")
        stub_zip_inputstream(body)

        expect(Generation).to receive(:upsert_all)
        subject
      end
    end

    context 'with file.csv' do
      let(:args) { ['path/to/file.csv'] }
      it
    end
    context 'with file.zip' do
      let(:args) { ['path/to/file.csv'] }
      it
    end

    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      it
    end
  end
  it "ignores sattelite records" do
    VCR.use_cassette("aemo_rooftoppv_sattelite") do
      expect(Generation).not_to receive(:upsert_all)
      AemoNem::RooftopPv.new("https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_ROOFTOP_PV_ACTUAL_SATELLITE_20230902183000_0000000396168830.zip").process
    end
  end
  it do
    VCR.use_cassette("aemo_rooftoppv_e2e") do
      expect(DataFile).to receive(:upsert)
      AemoNem::RooftopPv.new("https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168829.zip").process
    end
  end
end

RSpec.describe AemoNem::RooftopPvMMS do
  describe :cli do
    subject { AemoNem::RooftopPvMMS.cli(args) }
    let(:body) do
      <<-CSV
D,ROOFTOP,ACTUAL,2,"2023/09/13 04:30:00",NSW1,0,1,MEASUREMENT,"2023/09/13 04:49:11"
CSV
    end
    context 'with date range' do
      let(:args) { ['2023-01-01', '2023-02-01'] }
      it do
        stub_request(:get, 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2023/MMSDM_2023_01/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_ROOFTOP_PV_ACTUAL_202301010000.zip')
        stub_zip_inputstream(body)

        expect(Generation).to receive(:upsert_all)
        subject
      end
    end
  end
end
