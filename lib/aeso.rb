require 'fastest_csv'
require 'fast_jsonparser'
require 'chronic'
require 'zip'

module Aeso
  class Base
    TZ = TZInfo::Timezone.get('America/Edmonton')
    def self.source_id
      "aeso"
    end

    PT_MAP = {
      "ENERGY STORAGE" => :battery,
      "GAS" => :fossil_gas,
      "COAL" => :fossil_hard_coal
    }
  end

  class Generation < Base
    include SemanticLogger::Loggable

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
    QUEUE_URL = ENV['AESO_QUEUE_URL']
    QUEUE_REGION = 'us-east-2'
    include AwsSqs

    def initialize(file_or_body)
      @file_or_body = file_or_body
    end

    def process
      if @file_or_body.start_with? 'Current Supply Demand Report'
        chunks = @file_or_body.split("\r\n\r\n")
      elsif File.exist? @file_or_body
        chunks = File.read(@file_or_body).split("\r\n\r\n")
      else
        logger.error("Failed processing #{@file_or_body}")
        return
      end

      time = Time.strptime(chunks[1].strip, '"Last Update : %B %d, %Y %H:%M"')
      time = TZ.local_to_utc(time)
      @from = time
      @to = time + 1.minute

      r = []
      csv = FastestCSV.parse(chunks[3])
      csv.each do |row|
        production_type = PT_MAP[row[0]] || row[0].downcase.gsub(/ /, '_')
        next if production_type == 'total'
        value = row[2].to_f*1000

        r << {
          time:,
          country: 'CA-AB',
          production_type: production_type,
          value: value
        }
      end

      #transmission
      #@chunks[4]

      #units
      r_unit = process_units(time, :fossil_gas, chunks[5]) +
               process_units(time, :hydro, chunks[6]) +
               process_units(time, :battery, chunks[7]) +
               process_units(time, :solar, chunks[8]) +
               process_units(time, :wind, chunks[9]) +
               process_units(time, :other, chunks[10]) +
               process_units(time, :dual_fuel, chunks[11]) +
               process_units(time, :fossil_coal, chunks[12])
      #require 'pry' ; binding.pry

      ::Out2::Generation.run(r, @from, @to, self.class.source_id)
      ::Out2::Unit.run(r_unit, @from, @to, self.class.source_id)
    end

    def process_units time, production_type, chunk
      return [] if chunk.blank?
      r = []
      csv = FastestCSV.parse chunk
      csv.each do |row|
        next if row.length == 1
        next if row[0] == 'ASSET'

        #0: ASSET
        unit = row[0]
        unit.sub! /.*\((.*)\)/, '\1'
        #1: MC - Maximum Capability
        #2: TNG - Total Net Generation
        value = row[2].to_f*1000
        #3: DCR - Dispatched (and Accepted) Contingency Reserve
        r << {time:, country: 'CA-AB', production_type:, unit:, value:}
      end

      r
    end
  end

  class GenerationHistory < Base
    def self.cli args
      args.each do |file|
        self.new(file).process
      end
    end

    def initialize file
      @file = file
    end

    def process
      if @file =~ /\.zip$/
        zip = Zip::InputStream.new(@file)
        while zip.get_next_entry
          body = zip.read
          process_file(body)
        end
      end
    end

    TZ_MST = TZInfo::Timezone.get('MST')
    def process_file body
      r = []
      csv = FastestCSV.parse body, row_sep: "\r\n"
      country = Time.strptime(csv[2][0], '%Y-%m-%d %H:%M').min == 0 ? 'CA-AB-hourly' : 'CA-AB'
      csv.shift
      csv.each do |row|
        #0: Date (MST)
        time = Time.strptime(row[0], '%Y-%m-%d %H:%M')
        time = TZ_MST.local_to_utc(time)
        #1: Date (MPT)
        #2: Asset Short Name
        unit = row[2]
        #3: Asset Name
        #4: Asset Grouping
        #5: Volume
        value = (row[5].to_f*1000).round
        #6: Maximum Capability
        #7: System Capability
        #8: Fuel Type
        production_type = PT_MAP[row[8]] || row[8].downcase.gsub(/ /, '_')
        #9: Sub Fuel Type
        #10: Planning Area
        #11: Region
        r << {time:, country:, production_type:, unit:, value:}
      end
      #require 'pry' ; binding.pry
      from = r.first[:time]
      to = r.last[:time]

      ::Out2::Unit.run(r, from, to, self.class.source_id)
    end
  end

  class Price < Base
    include SemanticLogger::Loggable

    def self.cli args
      if args.length == 0 || args.length > 2
        $stderr.puts "#{$0}: <from> [to]"
        exit
      end
      from = Chronic.parse(args[0]).to_date
      to = Chronic.parse(args[1]).to_date if args[1]
      self.new(from, to).process
    end

    def self.each
      from = ::Price.joins(:area).where(areas: {source: self.source_id, code: 'CA-AB'}).where("time > ?", 2.month.ago).pluck(Arel.sql("LAST(time, time)")).first
      from = TZ.utc_to_local(from).to_date
      to = Time.now.in_time_zone(TZ).to_date

      self.new(from, to).process
    end

    def initialize from, to
      @from = from
      @to = to
    end

    URL = 'https://api.aeso.ca/report/v1.1/price/poolPrice'
    def process
      from = @from.strftime('%Y-%m-%d')
      to = @to.strftime('%Y-%m-%d') if @to.present?
      res = logger.benchmark_info("#{URL} #{from} #{to}") do
        Faraday.get(URL, startDate: from, endDate: to) do |req|
          req.headers['X-API-Key'] = ENV['AESO_TOKEN']
        end
      end
      json = FastJsonparser.parse(res.body, symbolize_keys: false)
      raise json['message'] if json['message']
      unless json['return'] && json['return']['Pool Price Report'].present?
        require 'pry' ; binding.pry
      end
      r = []
      json['return']['Pool Price Report'].each do |row|
        next if row['pool_price'].blank?
        time = Time.strptime(row['begin_datetime_utc'], '%Y-%m-%d %H:%M')
        value = row['pool_price'].to_f*100
        r << {time:, country: 'CA-AB', value:}
      end
      #require 'pry' ; binding.pry

      Out2::Price.run(r, r.first[:time], r.last[:time], self.class.source_id)
    end
  end
end
