require 'aws-sdk-sqs'
require 'fast_jsonparser'
require 'chronic'
require 'faraday/net_http_persistent'
require 'zip'
require 'mdb'
require 'tzinfo'

module Cammesa
  class Base
    TZ = TZInfo::Timezone.get('America/Sao_Paulo')
    def self.source_id
      'cammesa'
    end

    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%L%z'
    def parse_time(row)
      time = Time.strptime(row['fecha'], TIME_FORMAT)
    end

    def initialize
      @r = []
      @datafiles = []
    end

    def add(date)
      add_date(date)
    end

    def done!
      unless @r.empty?
        @from = @r.min { |a,b| a[:time] <=> b[:time] }[:time]
        @to = @r.max { |a,b| a[:time] <=> b[:time] }[:time]
        Out::Generation.run(@r, @from, @to, self.class.source_id)
      end
      DataFile.upsert_all(@datafiles, unique_by: [:source, :path])
    end
  end

  # https://cammesaweb.cammesa.com/generacion-real/
  class Renovables < Base
    include SemanticLogger::Loggable

    def self.each
      from = ::Generation.joins(:areas_production_type => [:area, :production_type]).where("time > ?", 2.months.ago).where(area: {source: self.source_id}, production_type: {name: ['wind','solar']}).pluck(Arel.sql("LAST(time, time)")).first
      from = TZ.utc_to_local(from).to_date
      (from..Date.today).each do |date|
        yield date
      end
    end

    URL = 'https://cdsrenovables.cammesa.com/exhisto/RenovablesService/GetChartTotalTRDataSource/'
    URL_TIME_FORMAT = '%d-%m-%Y'
    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
    end

    def self.cli(args)
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date
      (from...to).each do |date|
        new.add_date(date).done!
      end
    end

    def add_date(date)
      url = date.strftime(URL_TIME_FORMAT)
      response = @@faraday.get(URL, {desde: url, hasta: url})
      r = FastJsonparser.parse(response.body, symbolize_keys: false)
      if r.is_a?(Hash) && r['status'] == 'NOT_FOUND'
        raise EmptyError
      end
      add_json(r)
      self
    end

    def add_json(json)
      country = 'AR'
      json.each do |row|
        time = Time.strptime(row['momento'], TIME_FORMAT)
        @r << {time:, country:, production_type: 'biomass', value: row['biocombustible'].to_f*1000}
        @r << {time:, country:, production_type: 'hydro_small', value: row['hidraulica'].to_f*1000}
        @r << {time:, country:, production_type: 'solar', value: row['fotovoltaica'].to_f*1000}
        @r << {time:, country:, production_type: 'wind', value: row['eolica'].to_f*1000}
      end
    end
  end

  class ProgramacionDiaria < Base
    include SemanticLogger::Loggable

    LOOKUP_URL = 'https://api.cammesa.com/pub-svc/public/findDocumentosByNemoRango?fechadesde=%Y-%m-%dT%H:%M:%S.%LZ&fechahasta=%Y-%m-%dT%H:%M:%S.%LZ&nemo=PROGRAMACION_DIARIA'
    URL = 'https://api.cammesa.com/pub-svc/public/findAttachmentByNemoId'
    FILE_FORMAT = 'PD%y%m%d.zip'


    def self.each
      from = ::Generation.joins(:areas_production_type => [:area, :production_type]).where("time > ?", 2.months.ago).where(area: {source: self.source_id}, production_type: {name: ['thermal','nuclear','hydro']}).pluck(Arel.sql("LAST(time, time)")).first
      from = TZ.utc_to_local(from).to_date
      (from..Date.today).each do |date|
        yield date
      end
    end

    def self.cli(args)
      if File.exist? args.first
        args.each do |arg|
          new.add_file(arg).done!
        end
      else
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).each do |date|
          new.add_date(date).done!
        end
      end
    end

    def initialize
      super
      @r_gen = []
      @r_load = []
      @r_trans = []
    end

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      #f.response :logger, logger
    end

    def add_date(date)
      url = date.strftime(LOOKUP_URL)
      r = logger.benchmark_info(url) do
        @@faraday.get(url)
      end
      json = FastJsonparser.parse(r.body)
      json = json.select { |row| row[:adjuntos].first[:id] =~ /^PD\d{6}\.zip$/ }
      json.first[:adjuntos].first[:id]
      #binding.irb unless json.length == 1
      row = json.last

      binding.irb unless row[:adjuntos].length == 1
      params = {
        attachmentId: row[:adjuntos].first[:id],
        docId: row[:id],
        nemo: row[:nemo]
      }
      r2 = logger.benchmark_info(URL) do
        @@faraday.get(URL, params)
      end
      # path = "data/cammesa/#{row[:adjuntos].first[:id]}"
      # File.binwrite(path, r2.body)
      # puts path

      add_buffer(r2.body, date)
      self
    end

    def add_file(path)
      date = Time.strptime(File.basename(path), FILE_FORMAT).to_date
      add_buffer(File.open(path), date)
      self
    end

    FUEL_MAP = {
      'BO' => 'hydro_pumped_storage_charging',
      'EX' => 'export',
      'NE' => 'demand',
      # 'PE' => 'losses',
      # 'DE' => 'deficit',
      'HI' => 'hydro',
      'IM' => 'import',
      'NU' => 'nuclear',
      'TE' => 'thermal'
    }

    def add_buffer(body, date)
      country = 'AR'

      logger.benchmark_info("parse") do
        zip = Zip::InputStream.new(body)
        while entry = zip.get_next_entry
          case entry.name
          when /\.MDB$/
            f = Tempfile.new(entry.name, binmode: true)
            f.write(zip.read)
            mdb = Mdb.open(f.path)
            balance = mdb[:BALANCE]
            balance.select { |row| row[:RGE] == 'TOT' }.each do |row|
              production_type = FUEL_MAP[row[:COD]]
              next unless production_type
              row.each do |col,value|
                next unless col =~ /^H(\d\d)/
                h = $1.to_i - 1
                time = date + h.hours
                time = TZ.utc_to_local(time)
                value = value.to_f*1000
                value = -value if row[:COD] == 'BO'

                case row[:COD]
                when 'NE'
                  @r_load << {country:, time:, value:}
                when 'IM'
                  @r_trans << {time:, from_area: country, to_area: 'other', value:}
                when 'EX'
                  @r_trans << {time:, from_area: 'other', to_area: country, value:}
                else
                  @r_gen << {country:, production_type:, time:, value:}
                end
              end
              #binding.irb
            end
            f.close
            f.unlink
            #binding.irb
          end
        end
      end
      #binding.irb
    end

    def done!
      return if @r_gen.blank?
      @from = @r_gen.first[:time]
      @to = @r_gen.last[:time]

      Out::Generation.run(@r_gen, @from, @to, self.class.source_id)
      Out::Load.run(@r_load, @from, @to, self.class.source_id)
      Out::Transmission.run(@r_trans, @from, @to, self.class.source_id)
    end
  end
end
