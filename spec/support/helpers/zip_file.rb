module Helpers
  module ZipFile
    def stub_zip_file(body, name = 'name.zip')
      zip = double('Zip::File', count: 1)
      zip_entry = double('Zip::Entry', name:, time: nil)
      allow(::Zip::File).to receive(:open).and_yield(zip)
      allow(::Zip::File).to receive(:open_buffer).and_yield(zip)
      allow(zip).to receive(:entries) { [zip_entry] }
      allow(zip_entry).to receive(:get_input_stream) { zip_entry }
      allow(zip_entry).to receive(:mtime) { Time.now }
      expect(zip_entry).to receive(:read) { body }
    end
  end
end
