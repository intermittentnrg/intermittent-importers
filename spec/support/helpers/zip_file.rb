require 'zip'
require 'stringio'

module Helpers
  module ZipFile
    def create_zip_file(body, filename = 'file.csv', time = Zip::DOSTime.now)
      zip_buffer = StringIO.new
      Zip::OutputStream.write_buffer(zip_buffer) do |zio|
        entry = Zip::Entry.new(nil, filename)
        entry.time = time
        zio.put_next_entry(entry)
        zio.write(body)
      end

      zip_buffer
    end
  end
end
