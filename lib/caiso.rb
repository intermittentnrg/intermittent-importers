# frozen_string_literal: true

require 'faraday/net_http_persistent'
require 'faraday/retry'
require 'zip'
require 'fastest_csv'
require 'ox'
require 'chronic'

module Caiso
  class Base
    TZ = TZInfo::Timezone.get('US/Pacific')
    def self.source_id
      'caiso'
    end

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      # f.request :gzip
      # f.response :logger #, logger
    end

    def initialize
      @datafiles = []
    end

    def self.cli(args)
      if args.length != 2
        warn "#{$PROGRAM_NAME} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      e = new
      (from...to).each do |time|
        e.add_date(time)
      rescue EmptyError
        logger.warn "EmptyError #{time}"
      end
      e.done!
    end

    def add_date(date)
      @date = date
      @time = @date.to_time
      @from = TZ.local_to_utc(@time, &:first)
      @to = @from + 1.day
      url = date.strftime(self.class::URL_FORMAT)

      last_modified = DataFile.last_modified(url, self.class.source_id)
      res = @@faraday.get(url) do |req|
        req.headers['If-Modified-Since'] = last_modified if last_modified
      end

      raise EmptyError if res.headers['content-type'] =~ %r{^text/html}

      if res.status == 304
        logger.warn "304 Not Modified #{url}"
        return self
      end

      filedate = Time.httpdate(res.headers['Last-Modified'])

      add_buffer(res.body)
      @datafiles << { path: url, source: self.class.source_id, updated_at: filedate }

      self
    end

    def add(date)
      add_date(date)
    end

    def parse_time(value)
      time = @date.to_time + Time.strptime(value, '%H:%M').seconds_since_midnight.seconds

      TZ.local_to_utc(time, &:first)
    end

    def done!
      DataFile.upsert_all(@datafiles, unique_by: %i[source path])
      logger.info "done! #{@datafiles.map { |df| df[:path] }.join(', ')}"
    end
  end

  class FuelSource < Base
    include SemanticLogger::Loggable

    def self.each(&block)
      from = ::Generation.joins(areas_production_type: :area).where('time > ?',
                                                                    2.months.ago).where(area: { source: source_id }).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each(&block)
    end

    FUELS = {
      'Time' => nil,
      'Solar' => 'solar',
      'Wind' => 'wind_onshore',
      'Geothermal' => 'geothermal',
      'Biomass' => 'biomass',
      'Biogas' => 'biogas',
      'Small hydro' => 'hydro_small',
      'Coal' => 'fossil_hard_coal',
      'Nuclear' => 'nuclear',
      'Natural Gas' => 'fossil_gas',
      'Large Hydro' => 'hydro_large',
      'Batteries' => 'battery',
      'Imports' => 'import',
      'Other' => 'other'
    }.freeze
    FUEL_KEYS = FUELS.keys
    FUEL_VALUES = FUELS.values

    def initialize
      super
      @r_gen = []
      @r_trans = []
    end

    URL_FORMAT = 'https://www.caiso.com/outlook/history/%Y%m%d/fuelsource.csv'

    def add_buffer(body)
      csv = FastestCSV.parse(body, row_sep: "\r\n")
      @fields = csv.shift

      # Handle empty data
      raise EmptyError if @fields.empty? || @fields.first.to_s.strip == '' || @fields.first == "\n"

      from_area_id = Area.where(source: self.class.source_id, code: 'CAISO').pluck(:id).first
      to_area_id = Area.where(source: self.class.source_id, code: 'other').pluck(:id).first

      raise @fields.inspect unless @fields.map(&:downcase) == FUEL_KEYS.map(&:downcase)

      last_time = @from
      csv.each do |row|
        next if row[1..].compact.blank?

        # 0:Time
        time = parse_time(row[0])
        next if time < last_time

        last_time = time

        # 1:Solar
        # 2:Wind
        # 3:Geothermal
        # 4:Biomass
        # 5:Biogas
        # 6:Small hydro
        # 7:Coal
        # 8:Nuclear
        # 9:Natural Gas
        # 10:Large Hydro
        # 11:Batteries
        # 12:Imports
        # 13:Other

        row.each_with_index do |value, i|
          next if i.zero?
          raise i.to_s unless FUEL_VALUES[i]

          production_type = FUEL_VALUES[i]
          value = (value.to_f * 1000).to_i
          if production_type == 'import'
            @r_trans << {
              time:,
              from_area_id:,
              to_area_id:,
              value:
            }
          else
            @r_gen << {
              time:,
              production_type:,
              value:,
              country: 'CAISO'
            }
          end
        end
      end

      self
    end

    def done!
      return if @r_gen.empty? && @r_trans.empty?

      ::Out::Generation.run(@r_gen, @from, @to, self.class.source_id)
      ::Out::Transmission.run(@r_trans, @from, @to, self.class.source_id)

      super
    end
  end

  class Load < Base
    include SemanticLogger::Loggable

    VALIDATION_LOAD = {
      all: { min: 1000 }
    }.with_indifferent_access

    FIELDS = ['Time', 'Hour ahead forecast', 'Current demand', 'Net demand'].freeze

    def self.each(&block)
      from = ::Load.joins(:area).where('time > ?',
                                       2.months.ago).where(area: { source: source_id }).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each(&block)
    end

    def initialize
      super
      @r_load = []
    end

    URL_FORMAT = 'https://www.caiso.com/outlook/history/%Y%m%d/netdemand.csv'

    def add_buffer(body)
      csv = FastestCSV.parse(body, row_sep: "\r\n")
      @fields = csv.shift

      # Handle empty data
      raise EmptyError if @fields.empty? || @fields.first.to_s.strip == '' || @fields.first == "\n"

      raise @fields.inspect unless @fields[0..3].map(&:downcase) == FIELDS.map(&:downcase)

      last_time = @from
      csv.each do |row|
        next if row[2].blank?

        # 0:Time
        time = parse_time(row[0])
        next if time < last_time

        last_time = time
        # 1:Hour ahead forecast
        # 2:Current demand
        value = (row[2].to_f * 1000).to_i

        # 3:Net demand

        @r_load << {
          time:,
          value:,
          country: 'CAISO'
        }
      end

      self
    end

    def done!
      return if @r_load.empty?

      r_load = Validate.validate_load(@r_load, self.class::VALIDATION_LOAD)
      Out::Load.run(r_load, @from, @to, self.class.source_id)

      super
    end
  end

  class Price
    include SemanticLogger::Loggable

    SOURCE_ID = 'caiso'
    TZ = TZInfo::Timezone.get('US/Pacific')
    URL = 'https://oasis.caiso.com/oasisapi/SingleZip'

    def initialize
      @faraday = Faraday.new(request: { timeout: 120 }) do |f|
        f.request :retry, {
          exceptions: [
            Faraday::TooManyRequestsError,
            Faraday::TimeoutError
          ],
          interval: 1,
          backoff_factor: 2,
          max: 5
        }
        f.response :raise_error
      end
      @r_price = []
      @from = nil
      @to = nil
    end

    def self.cli(args)
      raise 'Arguments required' if args.empty?

      from = Chronic.parse(args[0]).to_date
      to = Chronic.parse(args[1] || args[0]).to_date

      (from..to).select { |d| d.day == 1 }.each do |date|
        month_end = [to, (date >> 1) - 1].min
        new.add_date_range(date, month_end).done!
      end
    end

    def add_date_range(from, to)
      @from = TZ.local_to_utc(from.to_time) { |periods| periods.first }
      @to = TZ.local_to_utc(to.to_time) { |periods| periods.first } + 1.day

      startdatetime = @from.strftime('%Y%m%dT%H:%M-0000')
      enddatetime = @to.strftime('%Y%m%dT%H:%M-0000')

      params = {
        queryname: 'PRC_LMP',
        version: 12,
        resultformat: 6,
        market_run_id: 'DAM',
        node: 'TH_SP15_GEN-APND',
        startdatetime: startdatetime,
        enddatetime: enddatetime
      }

      url = "#{self.class::URL}?#{URI.encode_www_form(params)}"

      res = logger.benchmark_info(url) { @faraday.get(url) }

      raise EmptyError if res.headers['content-type'] =~ %r{^text/html}

      add_buffer(res.body)

      self
    end

    def add_buffer(body)
      Zip::File.open_buffer(body) do |zip_file|
        zip_file.each do |entry|
          next if entry.directory?

          if entry.name.end_with?('.xml')
            xml_content = entry.get_input_stream.read
            xml_content.gsub!(/m:/, '')
            doc = Ox.parse(xml_content)
            err = doc.locate('OASISReport/MessagePayload/RTO/ERROR').first
            if err
              err_code = err.locate('ERR_CODE').first&.text
              err_desc = err.locate('ERR_DESC').first&.text
              logger.error "CAISO API error: #{err_code} - #{err_desc}"
            end
            return self
          end

          csv_content = entry.get_input_stream.read
          return self if csv_content.strip.empty?

          parse_csv(csv_content)
        end
      end

      self
    end

    def parse_csv(csv)
      rows = FastestCSV.parse(csv)
      headers = rows.shift

      time_idx = headers.index('INTERVALSTARTTIME_GMT')
      lmp_type_idx = headers.index('LMP_TYPE')
      mw_idx = headers.index('MW')

      raise 'Missing expected columns' unless time_idx && lmp_type_idx && mw_idx

      rows.each do |row|
        next unless row[lmp_type_idx] == 'LMP'

        time = Time.parse(row[time_idx]).utc
        price = (row[mw_idx].to_f * 1_000).to_i

        @r_price << { time:, country: 'CAISO', value: price }
      end

      self
    end

    def done!
      return if @r_price.empty?

      Out::Price.run(@r_price, @from, @to, self.class::SOURCE_ID)
    end
  end
end
