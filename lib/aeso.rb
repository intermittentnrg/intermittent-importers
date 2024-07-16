require 'fastest_csv'

class Aeso
  include SemanticLogger::Loggable

  #TZ = TZInfo::Timezone.get('MST')
  def self.source_id
    "aeso"
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

  MAX_RUNTIME = 1.minutes.to_i
  QUEUE_URL = ENV['AESO_QUEUE_URL']
  QUEUE_REGION = 'us-east-2'
  include AwsSqs

  def initialize(file_or_body)
    @file_or_body = file_or_body
  end

  MAPPING = {
    "ENERGY STORAGE" => :battery,
    "GAS" => :fossil_gas,
    "COAL" => :fossil_hard_coal
  }

  def process
    if @file_or_body.start_with? 'Current Supply Demand Report'
      @chunks = @file_or_body.split("\r\n\r\n")
    elsif File.exist? @file_or_body
      @chunks = File.read(@file_or_body).split("\r\n\r\n")
    else
      logger.error("Failed processing #{@file_or_body}")
      return
    end

    @time = Time.strptime(@chunks[1].strip, '"Last Update : %B %d, %Y %H:%M"')
    @from = @time
    @to = @time + 1.minute

    r = []
    csv = FastestCSV.parse(@chunks[3])
    csv.each do |row|
      production_type = MAPPING[row[0]] || row[0].downcase.gsub(/ /, '_')
      next if production_type == 'total'
      value = row[2].to_f*1000

      r << {
        time: @time,
        country: 'CA-AB',
        production_type: production_type,
        value: value
      }
    end
    #require 'pry' ; binding.pry

    ::Out2::Generation.run(r, @from, @to, self.class.source_id)
  end
end
