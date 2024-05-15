require 'aws-sdk-sqs'
require 'fast_jsonparser'
require 'chronic'
require 'faraday/net_http_persistent'
require 'zip'
require 'mdb'
#require 'peach'

module Cammesa
  class Base
    TZ = TZInfo::Timezone.get('America/Sao_Paulo')
    def self.source_id
      'cammesa'
    end
    def self.cli(args)
      if args.empty?
        each &:process
      else
        args.each do |f|
          self.new(f).process
        end
      end
    end

    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%L%z'
    def parse_time(row)
      time = Time.strptime(row['fecha'], TIME_FORMAT)
    end

    def initialize(file_or_body)
      @file_or_body = file_or_body
    end

    def parse
      if @file_or_body[0] == '{'
        FastJsonparser.parse(@file_or_body, symbolize_keys: false)
      else
        FastJsonparser.load(@file_or_body, symbolize_keys: false)
      end
    end
  end

  # https://cammesaweb.cammesa.com/
  # class Generacion < Base
  #   include Out::Generation
  #   include SemanticLogger::Loggable
  #   def points_generation
  #     #binding.irb
  #     r = []
  #     country = 'AR'
  #     json = parse
  #     json.each do |row|
  #       time = parse_time(row)
  #       r << {time:, country:, production_type: 'nuclear', value: row['nuclear'].to_f*1000}
  #       r << {time:, country:, production_type: 'hydro', value: row['hidraulico'].to_f*1000}
  #       r << {time:, country:, production_type: 'thermal', value: row['termico'].to_f*1000}
  #     end
  #     @from = r.first[:time]
  #     @to = r.last[:time]

  #     r
  #   end
  # end

  # https://cammesaweb.cammesa.com/generacion-real/
  class Renovables < Base
    include Out::Generation
    include SemanticLogger::Loggable

    def self.parsers_each
      from = ::Generation.joins(:areas_production_type => [:area, :production_type]).where("time > ?", 2.months.ago).where(area: {source: self.source_id}, production_type: {name: ['wind','solar']}).pluck(Arel.sql("LAST(time, time)")).first
      from = TZ.utc_to_local(from).to_date
      (from..Date.today).each do |date|
        new(date).process
      end
    end

    URL = 'https://cdsrenovables.cammesa.com/exhisto/RenovablesService/GetChartTotalTRDataSource/'
    PARAMS = {desde: '11-04-2024', hasta: '11-04-2024'}
    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
    end

    def self.cli(args)
      if args.length == 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).each do |date|
          new(date).process
        end
      else
        raise
      end
    end

    def initialize(date)
      @date = date.strftime(URL_TIME_FORMAT)
    end

    URL_TIME_FORMAT = '%d-%m-%Y'
    def fetch
      response = @@faraday.get(URL, {desde: @date, hasta: @date})
      FastJsonparser.parse(response.body, symbolize_keys: false)
    end

    def parse_time(row)
      Time.strptime(row['momento'], TIME_FORMAT)
    end
    def points_generation
      r = []
      json = fetch
      country = 'AR'
      json.each do |row|
        time = parse_time(row)
        r << {time:, country:, production_type: 'biomass', value: row['biocombustible'].to_f*1000}
        r << {time:, country:, production_type: 'hydro_small', value: row['hidraulica'].to_f*1000}
        r << {time:, country:, production_type: 'solar', value: row['fotovoltaica'].to_f*1000}
        r << {time:, country:, production_type: 'wind', value: row['eolica'].to_f*1000}
      end
      #binding.irb
      @from = r.first[:time]
      @to = r.last[:time]

      r
    end
  end

  # https://api.cammesa.com/demanda-svc/demanda/IntercambioCorredoresGeo/?id_region=1002
  # class Demanda < Base
  #   include Out::Transmission
  #   include SemanticLogger::Loggable

  #   def points
  #     from_area = 'AR'
  #     r = []

  #     json = parse
  #     json['features'].each do |row|
  #       p = row['properties']
  #       from_area, to_area = p['nombre'].split /-/
  #       next unless from_area == 'ARG'
  #       time = parse_time(p)
  #       value = p['text'].to_f*1000
  #       r << {time:, from_area: 'AR', to_area:, value:}
  #     end
  #     #binding.irb

  #     r
  #   end
  # end

  class ProgramacionDiaria < Base
    include SemanticLogger::Loggable

    LOOKUP_URL = 'https://api.cammesa.com/pub-svc/public/findDocumentosByNemoRango?fechadesde=%Y-%m-%dT%H:%M:%S.%LZ&fechahasta=%Y-%m-%dT%H:%M:%S.%LZ&nemo=PROGRAMACION_DIARIA'
    URL = 'https://api.cammesa.com/pub-svc/public/findAttachmentByNemoId'
    FILE_FORMAT = 'PD%y%m%d.zip'


    def self.parsers_each
      from = ::Generation.joins(:areas_production_type => [:area, :production_type]).where("time > ?", 2.months.ago).where(area: {source: self.source_id}, production_type: {name: ['thermal','nuclear','hydro']}).pluck(Arel.sql("LAST(time, time)")).first
      from = TZ.utc_to_local(from).to_date
      (from..Date.today).each do |date|
        new(date).process
      end
    end

    def self.cli(args)
      if File.exist? args.first
        args.each do |arg|
          new(arg).process
        end
      else
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        #(from...to).peach(2) do |date|
        (from...to).each do |date|
          new(date).process
        end
      end
    end

    def initialize(date_or_file)
      @date_or_file = date_or_file
    end

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      #f.response :logger, logger
    end

    def process
      if @date_or_file.is_a? Date
        @date = @date_or_file
        url = @date.strftime(LOOKUP_URL)
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

        process_file(StringIO.new(r2.body))
      else
        @date = Time.strptime(File.basename(@date_or_file), FILE_FORMAT).to_date
        process_file(File.new(@date_or_file))
      end
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

    def process_file(body)
      country = 'AR'
      r_gen = []
      r_load = []
      r_trans = []

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
                time = @date + h.hours
                time = TZ.utc_to_local(time)
                value = value.to_f*1000
                value = -value if row[:COD] == 'BO'

                case row[:COD]
                when 'NE'
                  r_load << {country:, time:, value:}
                when 'IM'
                  r_trans << {time:, from_area: country, to_area: 'other', value:}
                when 'EX'
                  r_trans << {time:, from_area: 'other', to_area: country, value:}
                else
                  r_gen << {country:, production_type:, time:, value:}
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
      @from = r_gen.first[:time]
      @to = r_gen.last[:time]

      Out2::Generation.run(r_gen, @from, @to, self.class.source_id)
      Out2::Load.run(r_load, @from, @to, self.class.source_id)
      Out2::Transmission.run(r_trans, @from, @to, self.class.source_id)
    end
  end
end
