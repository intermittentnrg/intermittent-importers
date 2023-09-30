module AemoNem
  class TradingMMS < Trading
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end

      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).select {|d| d.day==1}.each do |date|
        AemoNem::TradingMMS.new(date).process_price
      end
    end

    def initialize(date)
      url = date.strftime("https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_TRADINGPRICE_%Y%m010000.zip")
      @from = date
      @to = date + 1.month
      super(url)
    end
  end

  class ScadaMMS < Scada
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end

      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).select {|d| d.day==1}.each do |date|
        AemoNem::ScadaMMS.new(date).process
      end
    end

    def initialize(date)
      url = date.strftime("https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DISPATCH_UNIT_SCADA_%Y%m010000.zip")
      @from = TZ.local_to_utc(date.to_time)
      @to = @from + 1.month
      super(url)
    end
  end

  class RooftopPvMMS < RooftopPv
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end

      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).select {|d| d.day==1}.each do |date|
        AemoNem::RooftopPvMMS.new(date).process
      end
    end

    def initialize(date)
      url = date.strftime("https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_ROOFTOP_PV_ACTUAL_%Y%m010000.zip")
      @from = date
      @to = date + 1.month
      super(url)
    end
  end
end
