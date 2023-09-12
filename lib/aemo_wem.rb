module AemoWem
  class Base < ::Aemo::Base
    URL_BASE = "https://data.wa.aemo.com.au"

    def self.select_file? url
      url =~ /.csv$/i
    end
  end
  class ScadaWem < Base
    include SemanticLogger::Loggable
    include Out::Unit

    def self.cli(args)
      if args.length == 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        (from...to).select {|d| d.day==1}.each do |date|
          AemoWem::ScadaWem.new(date).process
        end
      elsif args.present?
        args.each do |path|
          AemoWem::ScadaWem.new(path).process
        end
      else
        AemoWem::ScadaWem.each &:process
      end
    end
    URL = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/"
    # MANIFEST: https://data.wa.aemo.com.au/public/public-data/manifests/facility-scada.yaml
    URL_FORMAT = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/facility-scada-%Y-%m.csv"
    def initialize(file_or_date)
      if file_or_date.is_a? Date
        super(file_or_date.strftime(URL_FORMAT))
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

    @@units = {}
    def process_rows(all)
      default_area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first
      require 'pry'
      #; binding.pry

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

  class Balancing
    URL_FORMAT = 'https://data.wa.aemo.com.au/datafiles/balancing-summary/balancing-summary-%Y.csv'

    def process_rows(all)
      #Trading Date
      #Interval Number
      #Trading Interval
      #Load Forecast (MW)
      #Forecast As At
      #Scheduled Generation (MW)
      #Non-Scheduled Generation (MW)
      #Total Generation (MW)
      #Final Price ($/MWh)
      #Extracted At

    end
  end
end

module AemoArchiveWem
  class ScadaArchive
    URL = "https://data.wa.aemo.com.au/datafiles/facility-scada/"
    TARGET = AemoWem::ScadaWem
  end
end
