require './spec/spec_helper'

RSpec.describe Aemo::Trading do
end
RSpec.describe Aemo::TradingMMS do
  describe :cli do
    it "iterates a single date" do
      instance = double('TradingMMS')
      expect(instance).to receive(:process_price)

      date = Date.new 2011,1,1
      expect(Aemo::TradingMMS).to receive(:new).once.with(date).and_return instance
      Aemo::TradingMMS.cli(['2011-01-01', '2011-01-02'])
    end
  end
end

RSpec.describe Aemo::TradingArchive do
  describe :each do
    it "processes directory" do
      VCR.use_cassette("aemo_trading_archive") do
        file_list = double('DataFile')
        expect(DataFile).to receive(:where).at_least(1).times.and_return file_list
        expect(file_list).to receive(:exists?).at_least(1).times.and_return false

        instance = double('Aemo::Trading')
        expect(Aemo::TradingArchive).to receive(:new).at_least(1).times.with(%r|^https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/PUBLIC_TRADINGIS_\d+_\d+.zip$|).and_return instance

        #arr = []
        #Aemo::TradingArchive.each { |b| arr << b  }
        #expect(arr).to eq [instance]*56
        expect { |b| Aemo::TradingArchive.each(&b) }.to yield_successive_args(*[instance]*56)
      end
    end
  end

  it "processes nested zips" do
    VCR.use_cassette("aemo_trading_archive_zip") do
      instance = double('Aemo::Trading')
      expect(instance).to receive(:process).at_least(1).times

      expect(Aemo::Trading).to receive(:new).at_least(1).times.and_return instance
      expect(DataFile).to receive :create
      Aemo::TradingArchive.new("https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/PUBLIC_TRADINGIS_20220724_20220730.zip").process
    end
  end
end
