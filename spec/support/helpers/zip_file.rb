require 'zip'
require 'stringio'

module Helpers
  module ZipFile
    def create_zip_file(body, filename = 'file.csv')
      zip_buffer = StringIO.new
      Zip::OutputStream.write_buffer(zip_buffer) do |zio|
        zio.put_next_entry(filename)
        zio.write(body)
      end

      zip_buffer
    end
  end
end
