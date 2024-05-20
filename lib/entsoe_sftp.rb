require 'net/sftp'

module EntsoeSftp
  class Base
    def self.each
      Net::SFTP.start('sftp-transparency.entsoe.eu', ENV['ENTSOE_USER'], :password => ENV['ENTSOE_PASSWORD']) do |sftp|
        sftp.dir.entries(self::DIR).sort { |a,b| b.name <=> a.name }.each do |entry|
          next if entry.name =~ /^\./
          time = Time.at(entry.attributes.mtime)
          # if time is greater
          if DataFile.where(path: entry.name, updated_at: time..., source: self::TARGET.source_id).present?
            logger.info "SKIP #{entry.name}"
            next
          else
            logger.info "GO #{entry.name}"
            data = StringIO.new(sftp.download!("#{self::DIR}/#{entry.name}"))

            self::TARGET.new(data, entry.name, time).process
          end
        end
      end
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::GenerationCSV
    DIR = '/TP_export/zip/AggregatedGenerationPerType_16.1.B_C'
  end

  class Unit < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::UnitCSV
    DIR = '/TP_export/zip/ActualGenerationOutputPerGenerationUnit_16.1.A'
  end

  class Load < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::LoadCSV
    DIR = '/TP_export/zip/ActualTotalLoad_6.1.A'
  end

  class Price < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::PriceCSV
    DIR = '/TP_export/zip/DayAheadPrices_12.1.D'
  end

  class Transmission < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::TransmissionCSV
    DIR = '/TP_export/zip/PhysicalFlows_12.1.G'
  end

  class Capacity < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::CapacityCSV
    DIR = '/TP_export/zip/InstalledGenerationCapacityAggregated_14.1.A'
  end

  class UnitCapacity < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::UnitCapacityCSV
    DIR = '/TP_export/zip/InstalledCapacityProductionUnit_14.1.B'
  end
end
