module AemoWem
  class Base < ::Aemo::Base
    TZ = TZInfo::Timezone.get('Etc/GMT-8')
    URL_BASE = "https://data.wa.aemo.com.au"
    INDEX_TIME_FORMAT = "%m/%d/%Y %I:%M %p"

    def self.cli(args)
      if args.length == 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        cli_range(from...to).each do |date|
          self.new(date).process
        end
      elsif args.present?
        args.each do |path|
          self.new(path).process
        end
      else
        self.each &:process
      end
    end

    def self.cli_range(range)
      range.select { |d| d.month==1 && d.day==1 }
    end

    def self.select_file? url
      url =~ /.csv$/i
    end

    def initialize(file_or_date)
      if file_or_date.is_a? Date
        super(file_or_date.strftime(self.class::URL_FORMAT))
      elsif file_or_date =~ /^https?:/
        super(file_or_date)
      else
        super(File.open(file_or_date, 'r'), file_or_date)
      end
    end

    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = TZ.local_to_utc(Time.strptime(s, "%Y-%m-%d %H:%M:%S"))
    end
  end



  class Scada < Base
    include SemanticLogger::Loggable
    include Out::Unit

    URL = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/"
    # MANIFEST: https://data.wa.aemo.com.au/public/public-data/manifests/facility-scada.yaml
    FILE_FORMAT = "facility-scada-%Y-%m.csv"
    URL_FORMAT = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/#{FILE_FORMAT}"

    def self.cli_range(range)
      range.select { |d| d.day==1 }
    end

    def initialize(file_or_date)
      if file_or_date.is_a? Date
        @from = file_or_date.to_time
      else
        @from = Time.strptime(File.basename(file_or_date), FILE_FORMAT)
      end
      @from = TZ.local_to_utc(@from)
      @to = @from + 1.month
      super
    end

    def process_rows(all)
      @units = {}
      @area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first

      all.shift
      dups = Set.new
      r = logger.benchmark_info("parse csv") do
        all.map do |row|
          # Trading Date
          # Interval Number
          # Trading Interval
          time = parse_time(row[2])
          # Participant Code
          # Facility Code
          unit_internal_id = row[4]
          unit = @units[unit_internal_id] ||= ::Unit.
                                               create_with(area_id: @area_id,
                                                           production_type_id: default_production_type_id).
                                               find_or_create_by!(internal_id: unit_internal_id)
          unit_id = unit.id
          # Energy Generated (MWh)
          # EOI Quantity (MW)
          value = row[6].to_f*1000
          # Extracted At
          #puts row.inspect if row[7].blank?
          next if row[2] == '2018-10-12 08:00:00' && row[3] == 'WPGENER' && row[4] == 'ALBANY_WF1'
          next if row[2] == '2018-10-12 08:00:00' && row[3] == 'WPGENER' && row[4] == 'GRASMERE_WF1'
          k = [time,unit_id]
          binding.pry if dups.include? k
          dups << k
          {time:, unit_id:, value:}
        end
      end
      r.compact!
      #require 'pry' ; binding.pry

      r
    end

    def done!
      where = "a.source='aemo' AND a.id=#{@area_id} and time BETWEEN '#{@from}' AND '#{@to}'"
      GenerationUnit.aggregate_to_generation(where)
      super
    end
  end

  class ScadaLive < Scada
    include SemanticLogger::Loggable
    URL = "https://aemo.com.au/aemo/data/wa/infographic/facility-intervals-last96.csv"
    def self.cli(args)
      if args.length > 1
        $stderr.puts "#{$0} [file.csv]"
        exit 1
      end
      self.new(*args).process
    end

    def initialize(url_or_path = URL)
      super(url_or_path)
    end
  end



  class Balancing < Base
    include SemanticLogger::Loggable

    URL = 'https://data.wa.aemo.com.au/datafiles/balancing-summary/'
    URL_FORMAT = 'https://data.wa.aemo.com.au/datafiles/balancing-summary/balancing-summary-%Y.csv'

    # FIXME: set @from and @to

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first

      all.shift
      load_r = []
      price_r = []

      all.map do |row|
        #Trading Date
        #Interval Number
        #Trading Interval
        time = parse_time(row[2])
        #Load Forecast (MW)
        #Forecast As At
        #Scheduled Generation (MW)
        #Non-Scheduled Generation (MW)
        #Total Generation (MW)
        load = row[7].to_f*1000
        #Final Price ($/MWh)
        price = row[8]
        #Extracted At

        load_r << {time:, area_id:, value: load}
        price_r << {time:, area_id:, value: price}
      end
      #require 'pry' ; binding.pry

      Out2::Load.run(load_r, @from, @to, self.class.source_id)
      Out2::Price.run(price_r, @from, @to, self.class.source_id)
    end
  end

  class BalancingLive < Balancing
    include SemanticLogger::Loggable
    URL = "https://data.wa.aemo.com.au/public/infographic/neartime/pulse.csv"
    def self.cli(args)
      if args.length > 1
        $stderr.puts "#{$0} [file.csv]"
        exit 1
      end
      self.new(*args).process
    end

    def initialize(url_or_path = URL)
      super(url_or_path)
    end
  end

  class DistributedPv < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = 'https://data.wa.aemo.com.au/public/public-data/datafiles/distributed-pv/'
    FILE_FORMAT = 'distributed-pv-%Y.csv'
    URL_FORMAT = "https://data.wa.aemo.com.au/public/public-data/datafiles/distributed-pv/#{FILE_FORMAT}"

    def initialize(file_or_date)
      if file_or_date.is_a? Date
        @from = file_or_date.to_time
      else
        @from = Time.strptime(File.basename(file_or_date), FILE_FORMAT)
      end
      @from = TZ.local_to_utc(@from)
      @to = @from + 1.year
      super
    end

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      all.shift
      r = all.map do |row|
        #Trading Date
        #Interval Number
        #Trading Interval
        time = parse_time(row[2])
        #Estimated DPV Generation (MW)
        value = row[3].to_f*1000
        #Extracted At
        {time:, area_id:, production_type: 'solar_rooftop', value:}
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
