require './spec/spec_helper'

def test_archive(index_name, archive_name = '123.zip', datafile_name = '123_456.zip')
  context "without arguments" do
    let(:index_body) do
      <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{archive_name}\"></A>
      HTML
    end

    it "calls process on target" do
      stub_request(:get, "https://nemweb.com.au/Reports/ARCHIVE/#{index_name}/").
        to_return(body: index_body)

      stub_request(:get, "https://nemweb.com.au/#{archive_name}")
      stub_zip_inputstream('', datafile_name)

      target = double(subject)
      expect(target).to receive(:process)
      expect(subject::TARGET).to receive(:new) { target }
      subject.cli([])
    end
  end

  context "with file.zip" do
    it "calls process on target" do
      file = double('File')
      expect(File).to receive(:open) { file }
      stub_zip_inputstream('', datafile_name)

      target = double(subject)
      expect(target).to receive(:process)
      #require 'pry' ; binding.pry
      expect(subject::TARGET).to receive(:new) { target }
      subject.cli(['file.zip'])
    end
  end
end

RSpec.describe AemoNemArchive::Scada do
  describe :cli do
    subject { AemoNemArchive::Scada }
    test_archive('Dispatch_SCADA')
  end
end

RSpec.describe AemoNemArchive::RooftopPv do
  describe :cli do
    subject { AemoNemArchive::RooftopPv }
    test_archive(
      'ROOFTOP_PV/ACTUAL',
      '/PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_.zip',
      'PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168830.zip'
    )
  end
end

RSpec.describe AemoNemArchive::Trading do
  describe :cli do
    subject { AemoNemArchive::Trading }
    test_archive('TradingIS_Reports')
  end

  describe :each do
    it "processes directory" do
      VCR.use_cassette("aemo_trading_archive") do
        file_list = double('DataFile')
        expect(DataFile).to receive(:where).at_least(1).times.and_return file_list
        expect(file_list).to receive(:exists?).at_least(1).times.and_return false

        instance = double('AemoNem::Trading')
        expect(AemoNemArchive::Trading).to receive(:new).at_least(1).times.with(%r|^https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/PUBLIC_TRADINGIS_\d+_\d+.zip$|).and_return instance

        #arr = []
        #AemoArchive::TradingArchive.each { |b| arr << b  }
        #expect(arr).to eq [instance]*56
        expect { |b| AemoNemArchive::Trading.each(&b) }.to yield_successive_args(*[instance]*56)
      end
    end
  end

  xit "processes nested zips" do
    VCR.use_cassette("aemo_trading_archive_zip") do
      instance = double('AemoNem::Trading')
      expect(instance).to receive(:process).at_least(1).times

      expect(AemoNem::Trading).to receive(:new).at_least(1).times.and_return instance
      expect(DataFile).to receive :create
      AemoNemArchive::Trading.new("https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/PUBLIC_TRADINGIS_20220724_20220730.zip").process
    end
  end
end
