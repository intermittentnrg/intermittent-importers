require './spec/spec_helper'

def test_archive(index_name, archive_name = '123.zip', datafile_name = '123_456.zip')
  context "without argument" do
    let(:index_body) do
      <<-HTML
<pre><A HREF="/public/public-data/datafiles/">[To Parent Directory]</A><br><br> Sunday, August 21, 2022  1:02 AM      1684350 <A HREF=\"/#{archive_name}\"></A>
      HTML
    end

    let(:mtime) { Zip::DOSTime.new(2025,12,10,9,6,43) }
    let(:zip_body) { create_zip_file('', datafile_name, mtime) }
    before do
      stub_request(:get, "https://nemweb.com.au/Reports/ARCHIVE/#{index_name}/").
        to_return(body: index_body)
      stub_request(:get, "https://nemweb.com.au/#{archive_name}").
        to_return(body: zip_body.string, headers: {last_modified: "Wed, 10 Dec 2025 09:06:43 GMT"})
    end
    it do
      target = double(subject)
      expect(target).to receive(:add_buffer)
      expect(target).to receive(:done!)
      expect(DataFile).to receive(:upsert_all).with(
        array_including(
          hash_including(
            source: 'aemo',
            updated_at: Time.strptime('Wed, 10 Dec 2025 09:06:43 GMT', '%a, %d %b %Y %H:%M:%S GMT')
          )
        ),
        unique_by: [:source, :path]
      )
      expect(subject::TARGET).to receive(:new) { target }
      subject.cli([])
    end
  end

  context "with file.zip" do
    it do
      file = create_zip_file('', datafile_name)
      allow(file).to receive(:size) { file.string.bytesize }
      expect(File).to receive(:open).with('file.zip') { file }

      target = double(subject)
      expect(target).to receive(:add_buffer)
      expect(target).to receive(:done!)
      expect(subject::TARGET).to receive(:new) { target }
      subject.cli(['file.zip'])
    end
  end
end

RSpec.describe AemoNemArchive::Dispatch do
  subject { AemoNemArchive::Dispatch }
  describe :cli do
    test_archive('DispatchIS_Reports')
  end
end

RSpec.describe AemoNemArchive::Scada do
  subject { AemoNemArchive::Scada }
  describe :cli do
    test_archive('Dispatch_SCADA')
  end
end

RSpec.describe AemoNemArchive::RooftopPv do
  subject { AemoNemArchive::RooftopPv }
  describe :cli do
    test_archive(
      'ROOFTOP_PV/ACTUAL',
      '/PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_.zip',
      'PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168830.zip'
    )
  end
end

RSpec.describe AemoNemArchive::Trading do
  subject { AemoNemArchive::Trading }
  describe :cli do
    test_archive('TradingIS_Reports')
  end
end
