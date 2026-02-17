# frozen_string_literal: true

require 'fast_jsonparser'
require 'faraday'
require 'zip'

class EntsoeFms
  class Base
    include SemanticLogger::Loggable
    include CliMixin2::MonthlyWithDownload

    @@faraday_auth = Faraday.new('https://keycloak.tp.entsoe.eu') do |f|
      f.request :url_encoded
      f.response :json
    end
    @@faraday = Faraday.new('https://fms.tp.entsoe.eu') do |f|
      f.request :authorization, 'Bearer', -> { token }
      f.request :json
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

    def self.refresh
      res = @@faraday.post('/listFolder', {
                             path: self::DIR,
                             sorterList: [{
                               key: 'periodCovered.from',
                               ascending: false
                             }],
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

        new.get_file(file['name'], time:)
      end

      logger.info "Skipped #{skipped.length} existing files"
    end

    def add_date(date, save_file: false)
      get_file(date.strftime(self.class::FILE_FORMAT), save_file:)
    end

    def get_file(file_name, time: nil, save_file: false)
      Tempfile.create([file_name, '.zip']) do |zip_tmp|
        zip_tmp.binmode
        logger.benchmark_info "Downloading #{file_name}" do
          @@faraday.post('/downloadFileContent', {
                           topLevelFolder: 'TP_export',
                           folder: self.class::DIR,
                           filename: file_name,
                           downloadAsZip: true
                         }) do |req|
            req.options.on_data = proc do |chunk, _overall_received_bytes, _env|
              zip_tmp.write(chunk)
            end
          end
        end
        zip_tmp.rewind
        self.class::TARGET.new.add_file(zip_tmp.path, name: file_name, time:, zip: true).done!
        if save_file
          FileUtils.mkdir_p('data/entsoe')
          File.rename(zip_tmp.path, "data/entsoe/#{file_name.gsub(/\.csv$/, '.zip')}")
        end
      end
    end

    def done!; end
  end

  class Generation < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::Generation
    DIR = '/TP_export/AggregatedGenerationPerType_16.1.B_C_r3/'
    FILE_FORMAT = '%Y_%m_AggregatedGenerationPerType_16.1.B_C_r3.csv'
  end

  class Unit < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::Unit
    DIR = '/TP_export/ActualGenerationOutputPerGenerationUnit_16.1.A_r3/'
    FILE_FORMAT = '%Y_%m_ActualGenerationOutputPerGenerationUnit_16.1.A_r3.csv'
  end

  class Load < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::Load
    DIR = '/TP_export/ActualTotalLoad_6.1.A_r3/'
    FILE_FORMAT = '%Y_%m_ActualTotalLoad_6.1.A_r3.csv'
  end

  class Price < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::Price
    DIR = '/TP_export/EnergyPrices_12.1.D_r3/'
    FILE_FORMAT = '%Y_%m_EnergyPrices_12.1.D_r3.csv'
  end

  class Transmission < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::Transmission
    DIR = '/TP_export/PhysicalFlows_12.1.G_r3/'
    FILE_FORMAT = '%Y_%m_PhysicalFlows_12.1.G_r3.csv'
  end

  class UnitCapacity < Base
    include SemanticLogger::Loggable

    TARGET = EntsoeCsv::UnitCapacity
    DIR = '/TP_export/InstalledCapacityProductionUnit_14.1.B/'
    FILE_FORMAT = '%Y_%m_InstalledCapacityProductionUnit_14.1.B.csv'
  end
end
