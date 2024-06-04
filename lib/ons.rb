require 'aws-sdk-sqs'
require 'fast_jsonparser'

class Ons
  include SemanticLogger::Loggable

  def self.source_id
    'ons'
  end
  def self.cli(args)
    if args.empty?
      each &:process
    else
      args.each do |f|
        #puts f
        self.new(f).process
      end
    end
  end

  MAX_RUNTIME = 15.minutes.to_i
  def self.each
    queue_url = ENV['ONS_QUEUE_URL']
    sqs = Aws::SQS::Client.new(region: 'sa-east-1')
    receipt_handles = []
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    loop do
      result = sqs.receive_message({
        queue_url: queue_url,
        max_number_of_messages: 10,
        visibility_timeout: MAX_RUNTIME,
        wait_time_seconds: 0 # Do not wait to check for the message.
      })
      result.messages.each do |message|
        body = message.body
        yield new(body)

        receipt_handles << message.receipt_handle
      end

      # FIXME Prevent long runs.
      # If it runs for more than 10 mins already processed messages can become visible again.
      break if (Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) >= MAX_RUNTIME

      break if result.messages.length <10
    end
    i=0
    receipt_handles.each_slice(10) do |batch|
      sqs.delete_message_batch({
        queue_url: queue_url,
        entries: batch.map do |receipt_handle|
          {
            id: (i += 1).to_s,
            receipt_handle:
          }
        end
      })
    end
    logger.info "deleted #{receipt_handles.length} from SQS"
  end

  def initialize(file_or_body)
    @file_or_body = file_or_body
  end

  REGIONS = {
    "BR-NE" => "nordeste",
    "BR-N" => "norte",
    "BR-CS" => "sudesteECentroOeste",
    "BR-S" => "sul"
  }

  def process
    if @file_or_body[0] == '{'
      json = FastJsonparser.parse(@file_or_body, symbolize_keys: false)
    else
      json = FastJsonparser.load(@file_or_body, symbolize_keys: false)
    end

    # handle SNS wrapping
    if json['Type'] == 'Notification'
      json = FastJsonparser.parse(json['Message'], symbolize_keys: false)
    end

    time = Time.strptime(json['Data'], '%Y-%m-%dT%H:%M:%S%:z')
    @from = time
    @to = time + 1.minute

    r_load = []
    r_gen = []
    r_trans = []
    REGIONS.each do |country, key|
      row = json[key]
      r_load << {time:, country:, value: row['cargaVerificada']*1000}

      g = row['geracao']
      r_gen << {time:, country:, production_type: 'hydro', value: (g['hidraulica']+g['itaipu50HzBrasil'].to_f+g['itaipu60Hz'].to_f)*1000}
      r_gen << {time:, country:, production_type: 'other', value: g['termica']*1000}
      r_gen << {time:, country:, production_type: 'wind', value: g['eolica']*1000}
      r_gen << {time:, country:, production_type: 'nuclear', value: g['nuclear']*1000}
      r_gen << {time:, country:, production_type: 'solar', value: g['solar']*1000}
    end

    t = json['internacional']
    r_trans << {time:, from_area: 'BR-S', to_area: 'AR', value: t['argentina']*1000}
    r_trans << {time:, from_area: 'BR-S', to_area: 'PY', value: t['paraguai']*1000}
    r_trans << {time:, from_area: 'BR-S', to_area: 'UY', value: t['uruguai']*1000}

    t = json['intercambio']
    r_trans << {time:, from_area: 'BR-S', to_area: 'BR-CS', value: t['sul_sudeste']*1000}
    r_trans << {time:, from_area: 'BR-CS', to_area: 'BR-NE', value: t['sudeste_nordeste']*1000}
    r_trans << {time:, from_area: 'BR-CS', to_area: 'BR-N', value: t['sudeste_norteFic']*1000}
    r_trans << {time:, from_area: 'BR-N', to_area: 'BR-NE', value: t['norteFic_nordeste']*1000}

    # skip bad data
    return if r_load.all? { |l| l[:value] == -2147220000000 }

    Out2::Load.run(r_load, @from, @to, self.class.source_id)
    Out2::Generation.run(r_gen, @from, @to, self.class.source_id)
    Out2::Transmission.run(r_trans, @from, @to, self.class.source_id)
  end
end
