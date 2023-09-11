module AemoArchive
  class Archive < ::Aemo::Base
    def initialize(file)
      if file.is_a? String
        @url = file
        http = logger.benchmark_info("Fetch #{file}") do
          http = @@faraday.get(file)
        end
        file = StringIO.new(http.body)
      end

      logger.benchmark_info("parse archive zip") do
        zip = Zip::InputStream.new(file)
        loop do
          zip_entry = zip.get_next_entry
          break if zip_entry.nil?
          next unless self.class::TARGET.select_file? zip_entry.name

          if DataFile.where(path: zip_entry.name, source: self.class.source_id).exists?
            logger.info "already processed #{zip_entry.name}"
            next
          end

          #zip_entry.get_input_stream doesn't respond to seek
          nested_zip = StringIO.new(zip_entry.get_input_stream.read)
          self.class::TARGET.new(nested_zip, zip_entry.name).process
        end
      end
    end

    def process
      done!
    end
  end

  class TradingArchive < Archive
    include SemanticLogger::Loggable

    URL = "https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/"
    TARGET = Aemo::Trading
  end

  class ScadaArchive < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/Dispatch_SCADA/'
    TARGET = Aemo::Scada
  end

  class RooftopPvArchive < Archive
    include SemanticLogger::Loggable

    URL = "https://nemweb.com.au/Reports/ARCHIVE/ROOFTOP_PV/ACTUAL/"
    TARGET = Aemo::RooftopPv

    def self.select_file? url
      super && url =~ /PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_/
    end
  end
end
