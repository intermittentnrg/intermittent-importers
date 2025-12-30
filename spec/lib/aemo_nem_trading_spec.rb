require './spec/spec_helper'

RSpec.describe AemoNem::Trading do
  describe :cli do
    subject { AemoNem::Trading.cli(args) }
    let(:body) do
      <<-CSV
D,TRADING,PRICE,3,"2023/09/13 05:30:00",1,SA1,66,129.96,0,0,"2023/09/13 05:25:02",129.96,0.39,0.39,1,1,0.49,0.49,3.38,3.38,0.14,0.14,0.38,0.38,0.2,0.2,1,1,0,0,0,0,FIRM
CSV
    end

    context 'with no arguments' do
      let(:args) { [] }
      let(:index_body) do
        <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{datafile_name}\"></A>
        HTML
      end
      let(:datafile_name) { 'PUBLIC_TRADINGIS_202511272330_0000000491329282.zip' }
      it do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/TradingIS_Reports/').
          to_return(body: index_body)
        stub_request(:get, 'https://nemweb.com.au/PUBLIC_TRADINGIS_202511272330_0000000491329282.zip').
          to_return(headers: {last_modified: "Wed, 10 Dec 2025 09:06:43 GMT"})
        stub_zip_file(body, 'PUBLIC_TRADINGIS_202511272330_0000000491329282.csv')

        expect(Price).to receive(:upsert_all)
        subject
      end
    end

    context "with file.zip" do
      it
    end
    context 'with file.csv' do
      it
    end
  end

  describe :parse_time do
    subject do
      time = "202308301800"
      url = "https://nemweb.com.au/Reports/Current/TradingIS_Reports/PUBLIC_TRADINGIS_#{time}_0000000395916754.zip"
      VCR.use_cassette("aemo_trading_#{time}") do
        AemoNem::Trading.new.add_url(url).done!
      end
    end
    it do
      expect(Out::Price).to receive(:run).with(array_including(hash_including(:time => Time.new(2023,8,30,8))), anything, anything, anything)
      subject
    end

    context 'NSW1' do
      it "has expected price" do
        expect(Out::Price).to receive(:run).with(array_including(hash_including(value: 29999)), anything, anything, anything)
        subject
      end
    end
  end
end
