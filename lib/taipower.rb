require 'fast_jsonparser'

module Taipower
  class Base
    include SemanticLogger::Loggable

    TZ = TZInfo::Timezone.get('Asia/Taipei')
    def self.source_id
      'taipower'
    end
  end

  class Generation < Base
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
    QUEUE_URL = ENV['TAIPOWER_QUEUE_URL']
    QUEUE_REGION = 'ap-east-1'
    include AwsSqs

    def initialize(file_or_body)
      @file_or_body = file_or_body
    end

    PT_MAP = {
      "NUCLEAR" => :nuclear,
      "COAL" => :fossil_coal,
      "COGEN" => :cogeneration,
      "IPPCOAL" => :fossil_coal,
      "LNG" => :fossil_gas,
      "IPPLNG" => :fossil_gas,
      "OIL" => :fossil_oil,
      "DIESEL" => :fossil_oil_diesel,
      "HYDRO" => :hydro,
      "WIND" => :wind,
      "SOLAR" => :solar,
      "PUMPINGGEN" => :hydro_pumped_storage,
      "OTHERRENEWABLEENERGY" => :other_renewable,
      "ENERGYSTORAGESYSTEM" => :storage,
      "ENERGYSTORAGESYSTEMLOAD" => :storage
    }

    def process
      if @file_or_body[0] == '{'
        json = FastJsonparser.parse(@file_or_body, symbolize_keys: false)
      else
        json = FastJsonparser.load(@file_or_body, symbolize_keys: false)
      end

      time = Time.strptime(json[''], '%Y-%m-%d %H:%M')
      time = TZ.local_to_utc(time)
      @from = time
      @to = time + 10.minutes
      @r_gen = {}
      @r_units = {}
      json['dataset'].each do |row|
        #0:fueltype
        row[0] =~ %r|<b>(.*)</b>|
        production_type = PT_MAP[$1]
        raise row.inspect unless production_type
        #1:blank
        case production_type
        when :wind
          if row[1].include? 'Onshore'
            production_type = :wind_onshore
          elsif row[1].include? 'Offshore'
            production_type = :wind_offshore
          end
        when :storage
          if row[1].include? 'Pumped'
            production_type = :hydro_pumped_storage
          elsif row[1].include? 'Battery'
            production_type = :battery
          end
        end
        #2:unit_id
        unit_id = row[2]
        unit_id.gsub! /\s?\(Remark.*\)/, ''
        if unit_id.include? 'Geothermal'
          production_type = :geothermal
        elsif unit_id.include? 'Biofuel'
          production_type = :biomass
        end
        #3:capacity
        #4:output
        value = (row[4].to_f*1000).to_i
        #5:output as % of capacity
        #6:remark
        #7:blank
        if unit_id.include? 'Subtotal'
          k = [time, production_type]
          @r_gen[k] ||= {time:, country: 'TW', production_type:, value: 0}
          @r_gen[k][:value] += value
        else
          k = [time, production_type, unit_id]
          @r_units[k] ||= {time:, country: 'TW', production_type:, unit: unit_id, value: 0}
          @r_units[k][:value] += value
        end
      end
      #require 'pry' ; binding.pry
      Out2::Generation.run(@r_gen.values, @from, @to, self.class.source_id)
      Out2::Unit.run(@r_units.values, @from, @to, self.class.source_id)
    end
  end
end
