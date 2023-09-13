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
      it do
        stub_request(:get, 'https://nemweb.com.au/Reports/Current/TradingIS_Reports/').
          to_return(body: '<A HREF="/123.zip"></A>')
        stub_request(:get, 'https://nemweb.com.au/123.zip')
        stub_zip_inputstream(body)

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
    subject :e do
      time = "202308301800"
      url = "https://nemweb.com.au/Reports/Current/TradingIS_Reports/PUBLIC_TRADINGIS_#{time}_0000000395916754.zip"
      VCR.use_cassette("aemo_trading_#{time}") do
        AemoNem::Trading.new(url)
      end
    end
    it { expect(subject.points_price.first[:time].utc).to eq Time.new(2023,8,30,8) }

    context 'NSW1' do
      subject :nsw do
        e.points.select { |row| row[:country] == 'NSW1' }.first
      end
      #it { require 'pry' ; binding.pry }
      it { expect(nsw[:value]).to eq 299.99 }
    end
  end
end

RSpec.describe AemoNem::TradingMMS do
  describe :cli do
    it do
    end
    it "iterates a single date" do
      instance = double('TradingMMS')
      expect(instance).to receive(:process_price)

      date = Date.new 2011,1,1
      expect(AemoNem::TradingMMS).to receive(:new).once.with(date).and_return instance
      AemoNem::TradingMMS.cli(['2011-01-01', '2011-01-02'])
    end
  end
end
