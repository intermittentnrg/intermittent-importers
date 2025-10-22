require 'fast_jsonparser'

class EntsoeFms

  class Base
    @@faraday_auth = Faraday.new('https://keycloak.tp.entsoe.eu') do |f|
      f.request :url_encoded
      f.response :json
    end
    @@faraday = Faraday.new('https://fms.tp.entsoe.eu') do |f|
      f.request :authorization, 'Bearer', -> { token }
      f.request :json
      #f.response :logger, nil, { bodies: true, log_level: :debug }
    end

    @@token = nil
    @@token_expires_at = Time.now

    def self.token
      return @@token if @@token && @@token_expires_at > Time.now + 60
      response = @@faraday_auth.post('/realms/tp/protocol/openid-connect/token', {
        client_id: 'tp-fms-public',
        grant_type: 'password',
        username: ENV['ENTSOE_USER'],
        password: ENV['ENTSOE_PASSWORD']
      })

      raise "Token request failed: #{response.status}" unless response.success?

      data = response.body
      @@token = data['access_token']
      @@token_expires_at = Time.now + data['expires_in'].to_i
      @@token
    end

    def self.each
      res = @@faraday.post('/listFolder', {
        path: self::DIR,
        sorterList: [],
        pageInfo: {
          pageIndex: 0,
          pageSize: 5000
        }
      })
      raise "Folder listing failed: #{res.status}" unless res.success?

      files = FastJsonparser.parse(res.body, symbolize_keys: false)['contentItemList']

      skipped = []

      files.each do |file|
        time = Time.parse(file['lastUpdatedTimestamp'])
        if DataFile.where(path: file['name'], updated_at: time, source: 'entsoe').exists?
          skipped << file['name']
          next
        end

        logger.info "Downloading #{file['name']}"
        content_res = @@faraday.post('/downloadFileContent', {
          topLevelFolder: 'TP_export',
          folder: self::DIR,
          filename: file['name'],
          downloadAsZip: true
        })
        raise "Download failed: #{content_res.status}" unless content_res.success?

        data = StringIO.new(content_res.body)
        self::TARGET.new(data, file['name'], time, true).process
      end

      logger.info "Skipped #{skipped.length} existing files"
    end
  end


  class Generation < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::GenerationCSV
    DIR = '/TP_export/AggregatedGenerationPerType_16.1.B_C/'
  end

  class Unit < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::UnitCSV
    DIR = '/TP_export/ActualGenerationOutputPerGenerationUnit_16.1.A_r2.1/'
  end

  class Load < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::LoadCSV
    DIR = '/TP_export/ActualTotalLoad_6.1.A/'
  end

  class Price < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::PriceCSV
    DIR = '/TP_export/EnergyPrices_12.1.D_r3/'
  end

  class Transmission < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::TransmissionCSV
    DIR = '/TP_export/PhysicalFlows_12.1.G_r3/'
  end

  class Capacity < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::CapacityCSV
    DIR = '/TP_export/InstalledGenerationCapacityAggregated_14.1.A_r3/'
  end

  class UnitCapacity < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::UnitCapacityCSV
    DIR = '/TP_export/InstalledCapacityProductionUnit_14.1.B/'
  end
end
