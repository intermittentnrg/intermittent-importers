module Helpers
  module ZipInputStream
    def stub_zip_inputstream(body, name = 'name.zip')
      zip = double('Zip::InputStream')
      expect(::Zip::InputStream).to receive(:new) { zip }
      allow(zip).to receive(:get_next_entry).and_return(zip, nil)
      expect(zip).to receive(:read) { body }
      allow(zip).to receive(:name) { name }
      allow(zip).to receive(:get_input_stream) { zip }
    end
  end
end
