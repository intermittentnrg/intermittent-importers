require './spec/spec_helper'

RSpec.describe AemoNem::RooftopPv do
  describe :cli do
    subject { AemoNem::RooftopPv }
    let(:body) do
      <<-CSV
D,ROOFTOP,ACTUAL,2,"2023/01/01 00:00:00",NSW1,0,1,MEASUREMENT,"2023/09/13 04:49:11"
CSV
    end

    context 'with no arguments' do
      let(:args) { [] }
      let(:index_body) do
        <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
        HTML
      end
      let(:datafile_name) { 'PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230101000000_0000000396168830.zip' }
      let(:zip_body) { create_zip_file(body, 'PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230101000000_0000000396168830.csv') }

      before do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/').
          to_return(body: index_body)
        stub_request(:get, "https://nemweb.com.au/#{datafile_name}").
          to_return(body: zip_body.string, headers: {last_modified: "Wed, 10 Dec 2025 09:06:43 GMT"})
      end
      it do
        expect(Generation).to receive(:upsert_all)
        subject.cli(args)
      end
      it do
        expect(Out::Generation).to receive(:run).with(anything, Time.new(2022,12,31,14,0), Time.new(2022,12,31,14,5), 'aemo')
        subject.cli(args)
      end
    end

    context 'with file.csv' do
      let(:args) { ['path/to/file.csv'] }
      it
    end
    context 'with file.zip' do
      let(:args) { ['path/to/file.zip'] }
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
      expect do
        AemoNem::RooftopPv.new.add_url("https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_ROOFTOP_PV_ACTUAL_SATELLITE_20230902183000_0000000396168830.zip").done!
      end.to raise_error(ArgumentError)
    end
  end
  it do
    VCR.use_cassette("aemo_rooftoppv_e2e") do
      expect(DataFile).to receive(:upsert_all)
      AemoNem::RooftopPv.new.add_url("https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168829.zip").done!
    end
  end
end
