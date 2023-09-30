module AemoNemArchive
  class Archive < ::AemoNem::Base
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

    def self.cli(args)
      if args.present?
        args.each do |file|
          self.new File.open(file)
        end
      else
        self.each &:process
      end
    end
  end

  class Trading < Archive
    include SemanticLogger::Loggable

    URL = "https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/"
    TARGET = AemoNem::Trading
  end

  class Scada < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/Dispatch_SCADA/'
    TARGET = AemoNem::Scada
  end

  class Dispatch < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/Archive/DispatchIS_Reports/'
    TARGET = AemoNem::Dispatch
  end

  class RooftopPv < Archive
    include SemanticLogger::Loggable

    URL = "https://nemweb.com.au/Reports/ARCHIVE/ROOFTOP_PV/ACTUAL/"
    TARGET = AemoNem::RooftopPv

    def self.select_file? url
      super && url =~ /PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_/
    end
  end
end
