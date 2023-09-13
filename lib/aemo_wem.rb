module AemoWem
  class Base < ::Aemo::Base
    URL_BASE = "https://data.wa.aemo.com.au"

    def self.cli(args)
      if args.length == 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).select {|d| d.day==1}.each do |date|
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
    URL_FORMAT = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/facility-scada-%Y-%m.csv"

    @@units = {}
    def process_rows(all)
      default_area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
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
          unit = @@units[unit_internal_id] ||= ::Unit.
                                               create_with(area_id: default_area_id,
                                                           production_type_id: default_production_type_id).
                                               find_or_create_by!(internal_id: unit_internal_id)
          unit_id = unit.id
          # Energy Generated (MWh)
          value = row[5].to_f*1000
          # EOI Quantity (MW)
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

        load_r << {time:, area_id:, value: load, source: self.class.source_id}
        price_r << {time:, area_id:, value: price, source: self.class.source_id}
      end
      #require 'pry' ; binding.pry

      Out2::Load.run(load_r, @from, @to, self.class.source_id)
      Out2::Price.run(price_r, @from, @to, self.class.source_id)
    end
    def process
      done!
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
end
