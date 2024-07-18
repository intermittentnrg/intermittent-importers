require 'fast_jsonparser'
require 'fastest_csv'

module Taipower
  class Base
    TZ = TZInfo::Timezone.get('Asia/Taipei')
    def self.source_id
      'taipower'
    end
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

  class GenerationDaily < Base
    include SemanticLogger::Loggable

    def self.cli(args)
      self.new(args[0]).process
    end

    def initialize(file_or_url)
      @file_or_url = file_or_url
    end

    URL = 'https://www.taipower.com.tw/d006/loadGraph/loadGraph/data/sys_dem_sup.csv'
    def process
      csv = nil
      if File.exist? @file_or_url
        csv = FastestCSV.read(@file_or_url, row_sep: "\r\n")
      else
        r = Faraday.get URL
        csv = FastestCSV.parse(@file_or_url, row_sep: "\r\n")
      end

      require 'pry' ; binding.pry
      country = 'TW-daily'
      r = []
      csv.each do |row|
        time = Time.strptime(row[0], '%Y%m%d')
        time = TZ.local_to_utc(time)

        #0: Net peaking capability (MW)
        #1: Instantaneous peak load (MW)
        #2: Operating Reserve (MW)
        #3: Percent Operating Reserve (%)
        #4: Power consumption(GWh) Industrial
        #5: Power consumption(GWh) General Public
        #6:
        ## Nuclear
        production_type = :nuclear
        #10: NPP2#2
        r << {time:, country:, production_type:, unit: 'NPP2#2', value: row[10].to_f*10000}
        #11: NPP3#1
        r << {time:, country:, production_type:, unit: 'NPP3#1', value: row[11].to_f*10000}
        #12: NPP3#2
        r << {time:, country:, production_type:, unit: 'NPP3#2', value: row[12].to_f*10000}

        ## Coal
        production_type = :fossil_coal
        #13: Linkou#1
        r << {time:, country:, production_type:, unit: 'Linkou#1', value: row[13].to_f*10000}
        #14: Linkou#2
        r << {time:, country:, production_type:, unit: 'Linkou#2', value: row[14].to_f*10000}
        #15: Linkou#3
        r << {time:, country:, production_type:, unit: 'Linkou#3', value: row[15].to_f*10000}
        #16: Taichung#1
        r << {time:, country:, production_type:, unit: 'Taichung#1', value: row[16].to_f*10000}
        #17: Taichung#2
        r << {time:, country:, production_type:, unit: 'Taichung#2', value: row[17].to_f*10000}
        #18: Taichung#3
        r << {time:, country:, production_type:, unit: 'Taichung#3', value: row[18].to_f*10000}
        #19: Taichung#4
        r << {time:, country:, production_type:, unit: 'Taichung#4', value: row[19].to_f*10000}
        #20: Taichung#5
        r << {time:, country:, production_type:, unit: 'Taichung#5', value: row[20].to_f*10000}
        #21: Taichung#6
        r << {time:, country:, production_type:, unit: 'Taichung#6', value: row[21].to_f*10000}
        #22: Taichung#7
        r << {time:, country:, production_type:, unit: 'Taichung#7', value: row[22].to_f*10000}
        #23: Taichung#8
        r << {time:, country:, production_type:, unit: 'Taichung#8', value: row[23].to_f*10000}
        #24: Taichung#9
        r << {time:, country:, production_type:, unit: 'Taichung#9', value: row[24].to_f*10000}
        #25: Taichung#10
        r << {time:, country:, production_type:, unit: 'Taichung#10', value: row[25].to_f*10000}
        #26: Xingda#1
        r << {time:, country:, production_type:, unit: 'Xingda#1', value: row[26].to_f*10000}
        #27: Xingda#2
        r << {time:, country:, production_type:, unit: 'Xingda#2', value: row[27].to_f*10000}
        #28: Xingda#3
        r << {time:, country:, production_type:, unit: 'Xingda#3', value: row[28].to_f*10000}
        #29: Xingda#4
        r << {time:, country:, production_type:, unit: 'Xingda#4', value: row[29].to_f*10000}
        #30 Dalin#1
        r << {time:, country:, production_type:, unit: 'Dalin#1', value: row[30].to_f*10000}
        #31: Dalin#2
        r << {time:, country:, production_type:, unit: 'Dalin#2', value: row[31].to_f*10000}

        ##IPP Coal
        #32: Hoping#1
        r << {time:, country:, production_type:, unit: 'Hoping#1', value: row[32].to_f*10000}
        #33: Hoping#2
        r << {time:, country:, production_type:, unit: 'Hoping#2', value: row[33].to_f*10000}
        #34: Mailiao#1
        r << {time:, country:, production_type:, unit: 'Mailiao#1', value: row[34].to_f*10000}
        #35: Mailiao#2
        r << {time:, country:, production_type:, unit: 'Mailiao#2', value: row[35].to_f*10000}
        #36: Mailiao#3
        r << {time:, country:, production_type:, unit: 'Mailiao#3', value: row[36].to_f*10000}

        ## Co-Gen
        production_type = :cogeneration
        #37: Co-Generation
        r << {time:, country:, production_type:, unit: 'Co-Generation', value: row[37].to_f*10000}

        ## LNG
        production_type = :fossil_gas
        #38: Datan (#1~#7)
        r << {time:, country:, production_type:, unit: 'Datan (#1~#7)', value: row[38].to_f*10000}
        #39: Tongxiao (#1~#6、GT#9)
        r << {time:, country:, production_type:, unit: 'Tongxiao (#1~#6、GT#9)', value: row[39].to_f*10000}
        #40: Xingda (#1~#5)
        r << {time:, country:, production_type:, unit: 'Xingda (#1~#5)', value: row[40].to_f*10000}
        #41: Nanbu (#1~#4)
        r << {time:, country:, production_type:, unit: 'Nanbu (#1~#4)', value: row[41].to_f*10000}
        #42: Dalin(#5、#6)
        r << {time:, country:, production_type:, unit: 'Dalin(#5、#6)', value: row[42].to_f*10000}
        ## IPP-LNG
        #43: Haihu (#1、#2)
        r << {time:, country:, production_type:, unit: 'Haihu (#1、#2)', value: row[43].to_f*10000}
        #44: Guoguang#1
        r << {time:, country:, production_type:, unit: 'Guoguang#1', value: row[44].to_f*10000}
        #45: Hsintao#1
        r << {time:, country:, production_type:, unit: 'Hsintao#1', value: row[45].to_f*10000}
        #46: Xingzhang#1
        r << {time:, country:, production_type:, unit: 'Xingzhang#1', value: row[46].to_f*10000}
        #47: Xingyuan#1
        r << {time:, country:, production_type:, unit: 'Xingyuan#1', value: row[47].to_f*10000}
        #48: Jiahui#1
        r << {time:, country:, production_type:, unit: 'Jiahui#1', value: row[48].to_f*10000}
        #49: Fongde(#1、#2)
        r << {time:, country:, production_type:, unit: 'Fongde(#1、#2)', value: row[49].to_f*10000}

        ## Oil
        production_type = :fossil_oil
        #50: Xiehe(#1~#4)
        r << {time:, country:, production_type:, unit: 'Xiehe(#1~#4)', value: row[50].to_f*10000}
        ## Diesel
        production_type = :fossil_oil_diesel
        #51: Gas turbine
        r << {time:, country:, production_type:, unit: 'Gas turbine', value: row[51].to_f*10000}
        #52: Outlying islands(Remark 2)
        r << {time:, country:, production_type:, unit: 'Outlying islands', value: row[52].to_f*10000}
        ## Hydro
        production_type = :hydro
        #53: Deji
        r << {time:, country:, production_type:, unit: 'Deji', value: row[53].to_f*10000}
        #54: Qingshan
        r << {time:, country:, production_type:, unit: 'Qingshan', value: row[54].to_f*10000}
        #55: Guguan
        r << {time:, country:, production_type:, unit: 'Guguan', value: row[55].to_f*10000}
        #56: Tienlun
        r << {time:, country:, production_type:, unit: 'Tienlun', value: row[56].to_f*10000}
        #57: Ma-an
        r << {time:, country:, production_type:, unit: 'Ma-an', value: row[57].to_f*10000}
        #58: Wanda
        r << {time:, country:, production_type:, unit: 'Wanda', value: row[58].to_f*10000}
        #59: Daguan
        r << {time:, country:, production_type:, unit: 'Daguan', value: row[59].to_f*10000}
        #60: Jugong
        r << {time:, country:, production_type:, unit: 'Jugong', value: row[60].to_f*10000}

        #63: Bihai
        r << {time:, country:, production_type:, unit: 'Bihai', value: row[63].to_f*10000}
        #64: Liwu
        r << {time:, country:, production_type:, unit: 'Liwu', value: row[64].to_f*10000}
        #65: Longjian
        r << {time:, country:, production_type:, unit: 'Longjian', value: row[65].to_f*10000}
        #66: Zhuolan
        r << {time:, country:, production_type:, unit: 'Zhuolan', value: row[66].to_f*10000}
        #67: Shuili
        r << {time:, country:, production_type:, unit: 'Shuili', value: row[67].to_f*10000}
        #68: Other small hydro (Remark 3)
        r << {time:, country:, production_type:, unit: 'Other small hydro', value: row[68].to_f*10000}

        ## Pumping Gen
        production_type = :hydro_pumped_storage
        #61: Daguan2
        r << {time:, country:, production_type:, unit: 'Daguan2', value: row[61].to_f*10000}
        #62: Mingtan
        r << {time:, country:, production_type:, unit: 'Mingtan', value: row[62].to_f*10000}

        ## Wind
        production_type = :wind
        #69: Wind power (Remark 4)
        r << {time:, country:, production_type:, unit: 'Wind power', value: row[69].to_f*10000}

        ## Solar
        production_type = :solar
        #70: Solar power (Remark 5)
        r << {time:, country:, production_type:, unit: 'Solar power', value: row[70].to_f*10000}
      end
      require 'pry' ; binding.pry
      Out2::Unit.run(r, nil, nil, self.class.source_id)
    end
  end
end
