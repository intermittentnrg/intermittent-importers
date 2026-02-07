# frozen_string_literal: true

require 'chronic'

module AemoNemMms
  module Base
    URL_BASE = 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/'
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
      def cli(args)
        if args.length == 1
          new.add_file(args.first).done!
          exit 0
        elsif args.length != 2
          warn "#{$PROGRAM_NAME} <from> <to>"
          exit 1
        end

        from = ::Chronic.parse(args.shift).to_date
        to = ::Chronic.parse(args.shift).to_date

        (from...to).select { |d| d.day == 1 }.each do |date|
          new.add_date(date).done!
        end
      end
    end

    module InstanceMethods
      def add_date(date)
        @from = self.class::TZ.local_to_utc(date.to_time)
        @to = @from + 1.month
        if date >= Date.new(2024, 8) && self.class::URL2.present?
          add_url(date.strftime(self.class::URL2))
        else
          add_url(date.strftime(self.class::URL))
        end

        self
      end

      def validate_filename!(name)
        m = self.class::FILE_MATCHER2.match(name) if self.class::FILE_MATCHER2.present?
        m ||= self.class::FILE_MATCHER.match(name)
        raise ArgumentError, "invalid filename: #{name}" unless m

        @from = Time.strptime(m[1], self.class::FILE_FORMAT)
      end
    end
  end

  class Trading < ::AemoNem::Trading
    include SemanticLogger::Loggable
    include Base
    FILE_MATCHER = /PUBLIC_DVD_TRADINGPRICE_(\d{12})/
    URL = "#{URL_BASE}PUBLIC_DVD_TRADINGPRICE_%Y%m010000.zip".freeze
  end

  class Dispatch < ::AemoNem::Dispatch
    include SemanticLogger::Loggable
    include Base
    FILE_MATCHER = /PUBLIC_DVD_DISPATCHREGIONSUM_(\d{12})/
    URL = "#{URL_BASE}PUBLIC_DVD_DISPATCHREGIONSUM_%Y%m010000.zip".freeze
  end

  class InterconnectorRes < ::AemoNem::Dispatch
    include SemanticLogger::Loggable
    include Base
    FILE_MATCHER = /PUBLIC_DVD_DISPATCHINTERCONNECTORRES_(\d{12})/
    URL = "#{URL_BASE}PUBLIC_DVD_DISPATCHINTERCONNECTORRES_%Y%m010000.zip".freeze
  end

  class Scada < ::AemoNem::Scada
    include SemanticLogger::Loggable
    include Base
    FILE_MATCHER = /PUBLIC_DVD_DISPATCH_UNIT_SCADA_(\d{12})/
    FILE_MATCHER2 = /PUBLIC_ARCHIVE#DISPATCH_UNIT_SCADA#FILE01#(\d{12})/
    URL = "#{URL_BASE}PUBLIC_DVD_DISPATCH_UNIT_SCADA_%Y%m010000.zip".freeze
    URL2 = "#{URL_BASE}PUBLIC_ARCHIVE%%23DISPATCH_UNIT_SCADA%%23FILE01%%23%Y%m010000.zip".freeze
  end

  class DuDetail < ::AemoNem::DuDetail
    include SemanticLogger::Loggable
    include Base
    FILE_MATCHER = /PUBLIC_DVD_DUDETAIL_(\d{12})/
    URL = "#{URL_BASE}PUBLIC_DVD_DUDETAIL_%Y%m010000.zip".freeze
  end

  class RooftopPv < ::AemoNem::RooftopPv
    include SemanticLogger::Loggable
    include Base
    FILE_MATCHER = /PUBLIC_DVD_ROOFTOP_PV_ACTUAL_(\d{12})/
    URL = "#{URL_BASE}PUBLIC_DVD_ROOFTOP_PV_ACTUAL_%Y%m010000.zip".freeze
  end
end
