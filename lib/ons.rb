require 'fast_jsonparser'

class Ons
  include SemanticLogger::Loggable

  def self.source_id
    'ons'
  end
  def self.cli(args)
    if args.empty?
      self.refresh
    else
      args.each do |f|
        self.new.add_file(f).done!
      end
    end
  end

  MAX_RUNTIME = 15.minutes.to_i
  QUEUE_URL = ENV['ONS_QUEUE_URL']
  QUEUE_REGION = 'sa-east-1'
  include AwsSqs

  def initialize
    super
    @r_load = {}
    @r_gen = {}
    @r_trans = {}
    @dups = Set.new
  end

  REGIONS = {
    "BR-NE" => "nordeste",
    "BR-N" => "norte",
    "BR-CS" => "sudesteECentroOeste",
    "BR-S" => "sul"
  }

  def add_file path
    add_json FastJsonparser.load(path, symbolize_keys: false)

    self
  end

  def add_buffer body
    if body[0..5] == '<head>'
      logger.error "Body is HTML: #{body}"
      return
    end
    add_json FastJsonparser.parse(body, symbolize_keys: false)
  end

  def add_json json
    # handle SNS wrapping
    if json['Type'] == 'Notification'
      json = FastJsonparser.parse(json['Message'], symbolize_keys: false)
    end

    time = Time.strptime(json['Data'], '%Y-%m-%dT%H:%M:%S%:z')
    if @dups.include? time
      logger.warn "Skipping duplicate in batch #{time}"
      return
    end
    @dups << time

    @from = [time, @from].compact.min
    @to = [time + 1.minute, @to].compact.max

    REGIONS.each do |country, key|
      row = json[key]
      k = [time, country]
      @r_load[k] = {time:, country:, value: row['cargaVerificada']*1000}

      g = row['geracao']
      @r_gen[[*k, 'hydro']] = {time:, country:, production_type: 'hydro', value: (g['hidraulica']+g['itaipu50HzBrasil'].to_f+g['itaipu60Hz'].to_f)*1000}
      @r_gen[[*k, 'other']] = {time:, country:, production_type: 'other', value: g['termica']*1000}
      @r_gen[[*k, 'wind']] = {time:, country:, production_type: 'wind', value: g['eolica']*1000}
      @r_gen[[*k, 'nuclear']] = {time:, country:, production_type: 'nuclear', value: g['nuclear']*1000}
      @r_gen[[*k, 'solar']] = {time:, country:, production_type: 'solar', value: g['solar']*1000}
    end

    t = json['internacional']
    @r_trans[[time, 'AR']] = {time:, from_area: 'BR-S', to_area: 'AR', value: t['argentina']*1000}
    @r_trans[[time, 'PY']] = {time:, from_area: 'BR-S', to_area: 'PY', value: t['paraguai']*1000}
    @r_trans[[time, 'UY']] = {time:, from_area: 'BR-S', to_area: 'UY', value: t['uruguai']*1000}

    t = json['intercambio']
    @r_trans[[time, 'S-CS']] = {time:, from_area: 'BR-S', to_area: 'BR-CS', value: t['sul_sudeste']*1000}
    @r_trans[[time, 'CS-NE']] = {time:, from_area: 'BR-CS', to_area: 'BR-NE', value: t['sudeste_nordeste']*1000}
    @r_trans[[time, 'CS-N']] = {time:, from_area: 'BR-CS', to_area: 'BR-N', value: t['sudeste_norteFic']*1000}
    @r_trans[[time, 'N-NE']] = {time:, from_area: 'BR-N', to_area: 'BR-NE', value: t['norteFic_nordeste']*1000}
  end

  def done!
    r_gen = Validate.validate_generation(@r_gen.values, self.class.source_id)
    Out::Generation.run(r_gen, @from, @to, self.class.source_id)
    Out::Load.run(@r_load.values, @from, @to, self.class.source_id)
    Out::Transmission.run(@r_trans.values, @from, @to, self.class.source_id)
  end
end
