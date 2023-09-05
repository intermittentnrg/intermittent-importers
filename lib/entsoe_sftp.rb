require 'net/sftp'

module EntsoeSFTP
  class Base
    def self.each
      Net::SFTP.start('sftp-transparency.entsoe.eu', ENV['ENTSOE_USER'], :password => ENV['ENTSOE_PASSWORD']) do |sftp|
        sftp.dir.foreach(self::DIR) do |entry|
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

    TARGET = EntsoeCSV::GenerationCSV
    DIR = '/TP_export/zip/AggregatedGenerationPerType_16.1.B_C'
  end

  class Unit < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCSV::UnitCSV
    DIR = '/TP_export/zip/ActualGenerationOutputPerGenerationUnit_16.1.A'
  end

  class Load < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCSV::LoadCSV
    DIR = '/TP_export/zip/ActualTotalLoad_6.1.A'
  end

  class Price < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCSV::PriceCSV
    DIR = '/TP_export/zip/DayAheadPrices_12.1.D'
  end
end
