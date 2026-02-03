require 'zip'
require 'stringio'

module Helpers
  module ZipFile
    def create_zip_file(body, filename = 'file.csv', time = Zip::DOSTime.now)
      zip_buffer = StringIO.new
      Zip::OutputStream.write_buffer(zip_buffer) do |zio|
        # Handle multiple files
        if body.is_a?(Array) && filename.is_a?(Array)
          body.zip(filename).each do |file_body, file_name|
            entry = Zip::Entry.new(nil, file_name)
            entry.time = time
            zio.put_next_entry(entry)
            zio.write(file_body)
          end
        else
          # Handle single file (original behavior)
          entry = Zip::Entry.new(nil, filename)
          entry.time = time
          zio.put_next_entry(entry)
          zio.write(body)
        end
      end

      zip_buffer
    end
  end
end
