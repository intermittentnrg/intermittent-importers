# frozen_string_literal: true

module AemoNemArchive
  class Archive < ::AemoNem::Base
    def initialize(file)
      super()
      @datafiles = []
      if file.is_a? String
        last_modified = DataFile.last_modified(file, self.class.source_id)
        res = logger.benchmark_info("Fetch #{file}") do
          @faraday.get(file) do |req|
            req.headers['If-Modified-Since'] = last_modified if last_modified
          end
        end
        last_modified = Time.httpdate(res.headers['Last-Modified'])
        @datafiles << { path: File.basename(file), updated_at: last_modified, source: self.class.source_id }
        file = StringIO.new(res.body)
      end

      Zip::File.open(file, buffer: true) do |zip|
        paths = zip.entries.map &:name
        datafiles = Hash[DataFile.where(path: paths, source: self.class.source_id).map do |datafile|
          [datafile.path, datafile]
        end]

        target = self.class::TARGET.new
        zip.entries.each do |zip_entry|
          datafile = datafiles[zip_entry.name]
          if datafile.present? && datafile.updated_at >= zip_entry.time
            logger.info "already processed #{zip_entry.name}"
            next
          end
          next unless self.class::TARGET.select_file? zip_entry.name

          target.add_buffer(zip_entry.get_input_stream.read, zip_entry.name, zip_entry.time)
        end
        target.done!
      end
    end

    def self.cli(args)
      if args.present?
        args.each do |path|
          new(File.open(path)).done!
        end
      else
        each do |url|
          new(url).done!
        end
      end
    end
  end

  class Trading < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/'
    TARGET = AemoNem::Trading
  end

  class Scada < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/Dispatch_SCADA/'
    TARGET = AemoNem::Scada
  end

  class Dispatch < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/DispatchIS_Reports/'
    TARGET = AemoNem::Dispatch
  end

  class RooftopPv < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/ROOFTOP_PV/ACTUAL/'
    TARGET = AemoNem::RooftopPv

    def self.select_file?(url)
      super && url =~ /PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_/
    end
  end
end
