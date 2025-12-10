module AemoNemArchive
  class Archive < ::AemoNem::Base
    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
    def initialize(file)
      if file.is_a? String
        @url = file
        last_modified = DataFile.last_modified(@url, self.class.source_id)
        res = logger.benchmark_info("Fetch #{file}") do
          @@faraday.get(file) do |req|
            req.headers['If-Modified-Since'] = last_modified if last_modified
          end
        end
        @filedate = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)
        file = StringIO.new(res.body)
      end

      Zip::File.open(file, buffer: true) do |zip|
        paths = zip.entries.map &:name
        datafiles = Hash[DataFile.where(path: paths, source: self.class.source_id).map do |datafile|
          [datafile.path, datafile]
        end]

        zip.entries.each do |zip_entry|
          datafile = datafiles[zip_entry.name]
          #unless zip_entry.time > datafile.updated_at
          if datafile.present?
            logger.info "already processed #{zip_entry.name}"
            next
          end
          next unless self.class::TARGET.select_file? zip_entry.name

          nested_zip = StringIO.new(zip_entry.get_input_stream.read)
          self.class::TARGET.new(nested_zip, zip_entry.name, zip_entry.time).process
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
