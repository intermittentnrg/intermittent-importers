require 'chronic'

module AemoNemMms
  module Base
    URL_BASE = "https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/"
    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end
    module ClassMethods
      def cli(args)
        if args.length != 2
          $stderr.puts "#{$0} <from> <to>"
          exit 1
        end

        from = ::Chronic.parse(args.shift).to_date
        to = ::Chronic.parse(args.shift).to_date

        (from...to).select {|d| d.day==1}.each do |date|
          self.new(date).process
        end
      end
    end
    module InstanceMethods
      def initialize(date)
        url = date.strftime(self.class::URL)
        @from = self.class::TZ.local_to_utc(date.to_time)
        @to = @from + 1.month
        super(url)
      end
    end
  end

  class Trading < ::AemoNem::Trading
    include SemanticLogger::Loggable
    include Base
    URL = URL_BASE + "PUBLIC_DVD_TRADINGPRICE_%Y%m010000.zip"
  end

  class Dispatch < ::AemoNem::Dispatch
    include SemanticLogger::Loggable
    include Base
    URL = URL_BASE + "PUBLIC_DVD_DISPATCHREGIONSUM_%Y%m010000.zip"
  end

  class Scada < ::AemoNem::Scada
    include SemanticLogger::Loggable
    include Base
    URL = URL_BASE + "PUBLIC_DVD_DISPATCH_UNIT_SCADA_%Y%m010000.zip"
  end

  class GenUnits < ::AemoNem::GenUnits
    include SemanticLogger::Loggable
    include Base
    URL = URL_BASE + "PUBLIC_DVD_GENUNITS_%Y%m010000.zip"
  end

  class DuDetail < ::AemoNem::DuDetail
    include SemanticLogger::Loggable
    include Base
    URL = URL_BASE + "PUBLIC_DVD_DUDETAIL_%Y%m010000.zip"
  end

  class RooftopPv < ::AemoNem::RooftopPv
    include SemanticLogger::Loggable
    include Base
    URL = URL_BASE + "PUBLIC_DVD_ROOFTOP_PV_ACTUAL_%Y%m010000.zip"
  end
end
