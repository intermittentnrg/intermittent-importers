# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'date'
require 'httparty'
require 'rexml/document'
require 'active_support'
require 'active_support/core_ext'

class ENTSOE
  DEFAULT_START = DateTime.parse('2014-01-01')

  #4.4.5. Current Generation Forecasts for Wind and Solar [14.1.D]
  #GET /api?documentType=A69&processType=A18&psrType=B16&in_Domain=10YCZ-CEPS-----N&periodStart=201512312300&periodEnd=201612312300
  class WindSolar < ENTSOE
    def initialize(country: nil, **kwargs)
      super(**kwargs)
      @country = country
      @options[:documentType] = 'A69'
      @options[:processType] = PROCESS_TYPES[:current]
      @options[:in_Domain] = COUNTRIES[country.to_sym]
      fetch
    end
    def points
      data = super
      data.each { |p| p.slice!(:country) }
      data
    end
  end

  #4.4.8. Aggregated Generation per Type [16.1.B&C]
  #GET /api?documentType=A75&processType=A16&psrType=B02&in_Domain=10YCZ-CEPS-----N&periodStart=201512312300&periodEnd=201612312300
  class Generation < ENTSOE
    def initialize(country: nil, **kwargs)
      super(**kwargs)
      @country = country
      @process_type = :realised
      @options[:documentType] = 'A75'
      @options[:processType] = PROCESS_TYPES[:realised]
      @options[:in_Domain] = COUNTRIES[country.to_sym]
      fetch
    end

    def points
      super.select { |p| !(p[:country] == :NO && p[:production_type] == 'wind_onshore' && p[:value] > 10_000) }
    end
  end

  #4.1.1. Actual Total Load [6.1.A]
  #GET /api?documentType=A65&processType=A16&outBiddingZone_Domain=10YCZ-CEPS-----N&periodStart=201512312300&periodEnd=201612312300
  class Load < ENTSOE
    def initialize(country:, **kwargs)
      super(**kwargs)
      @country = country
      @process_type = :realised
      @options[:documentType] = 'A65'
      @options[:processType] = PROCESS_TYPES[:realised]
      @options[:outBiddingZone_Domain] = COUNTRIES[country.to_sym]
      fetch
    end
    def points
      data = super
      data.each { |p| p.except!(:process_type, :production_type) }
      data
    end
  end

  class Price < ENTSOE
    def initialize(country:, **kwargs)
      super(**kwargs)
      @country = country
      @options[:documentType] = 'A44'
      @options[:in_domain] = @options[:out_Domain] = COUNTRIES[country.to_sym]
      fetch
    end
    def point(p)
      {
        country: @country,
        time: @time,
        value: p.elements.to_a('price.amount').first.text.to_i
      }
    end
  end

  #4.2.15. Physical Flows [12.1.G]
  #GET /api?documentType=A11&in_Domain=10YCZ-CEPS-----N&out_Domain=10YSK-SEPS-----K&periodStart=201512312300&periodEnd=201612312300
  class Transmission < ENTSOE
    def initialize(from_area:, to_area:, **kwargs)
      super(**kwargs)
      @from_area, @to_area = from_area, to_area
      @options[:documentType] = 'A11'
      @options[:out_Domain] = COUNTRIES[from_area.to_sym]
      @options[:in_Domain] = COUNTRIES[to_area.to_sym]
      puts @options.inspect
      fetch
      @doc1 = @doc

      @options[:out_Domain] = COUNTRIES[to_area.to_sym]
      @options[:in_Domain] = COUNTRIES[from_area.to_sym]
      fetch
    end

    def points
      r={}
      @doc1.elements.each('*/TimeSeries') do |ts|
        start = DateTime.strptime(ts.elements.to_a('Period/timeInterval/start').first.text, '%Y-%m-%dT%H:%M%z')
        resolution = ts.elements.to_a('Period/resolution').first.text.match(/^PT(\d+)M$/) { |m| m[1].to_i }

        data = ts.elements.each('Period/Point') do |p|
          @time = start + ((p.elements.to_a('position').first.text.to_i - 1) * resolution).minutes
          @last_time = @time
          r[@time] = p.elements.to_a('quantity').first.text.to_i
        end
      end
      @doc.elements.each('*/TimeSeries') do |ts|
        start = DateTime.strptime(ts.elements.to_a('Period/timeInterval/start').first.text, '%Y-%m-%dT%H:%M%z')
        resolution = ts.elements.to_a('Period/resolution').first.text.match(/^PT(\d+)M$/) { |m| m[1].to_i }

        data = ts.elements.each('Period/Point') do |p|
          @time = start + ((p.elements.to_a('position').first.text.to_i - 1) * resolution).minutes
          @last_time = @time
          r[@time] -= p.elements.to_a('quantity').first.text.to_i
        end
      end

      r.map do |k,v|
        {
          time: k,
          from_area: @from_area,
          to_area: @to_area,
          value: v
        }
      end
    end
  end

  class EmptyError < StandardError
  end

  def self.source_id
    "entsoe"
  end

  def initialize from: DateTime.now.beginning_of_day, to: DateTime.now.beginning_of_hour, psr_type: nil
    raise "#{from} == #{to}" if from==to
    @options = {
      #psrType: 'B16',
      #in_Domain: '10YCZ-CEPS-----N',
      #periodStart:'202109200000',
      #periodEnd:  '202109220000',
      securityToken: ENV['ENTSOE_TOKEN']
    }
    @options[:psrType] = psr_type if psr_type.present?
    #@options[:periodStart] = options[:start] || '202109202300'
    #@options[:periodEnd] = options[:end] || '202109222300'
    @options[:TimeInterval] = "#{from}/#{to}"
  end

  def fetch
    res = HTTParty.get(
      'https://transparency.entsoe.eu/api',
      query: @options,
      #debug_output: $stdout
    )
    #puts res.body
    @doc = REXML::Document.new res.body

    code, reason = @doc.elements.to_a("*/Reason/*").map(&:text)
    if reason.present?
      raise EmptyError if reason =~ /No matching data found/
      raise reason
    end
  end

  def points
    r=[]
    @doc.elements.each('*/TimeSeries') do |ts|
      next if is_a?(Generation) && ts.elements.to_a('outBiddingZone_Domain.mRID').first
      #unless ts.elements.to_a('inBiddingZone_Domain.mRID').first
      #  require 'pry' ; binding.pry
      #end
      start = DateTime.strptime(ts.elements.to_a('Period/timeInterval/start').first.text, '%Y-%m-%dT%H:%M%z')
      #2020-12-31T23:00Z
      resolution = ts.elements.to_a('Period/resolution').first.text.match(/^PT(\d+)M$/) { |m| m[1].to_i }

      #business_type = ts.css('businessType').text

      psr = ts.elements.to_a('MktPSRType/psrType').first.try :text
      @production_type = PARAMETER_DESC[psr.to_sym].downcase.tr_s(' ', '_') if psr

      data = ts.elements.each('Period/Point') do |p|
        @time = start + ((p.elements.to_a('position').first.text.to_i - 1) * resolution).minutes
        @last_time = @time
        r << point(p)
      end
    end

    r
  end

  def point(p)
    {
      country: @country,
      process_type: @process_type,
      production_type: @production_type,
      time: @time,
      value: p.elements.to_a('quantity').first.text.to_i
    }
  end

  def last_time
    unless @last_time
      require 'pry'
      binding.pry
    end
    @last_time
  end

  PROCESS_TYPES = {
    current: 'A18',
    intraday: 'A40',
    dayahead: 'A01',
    realised: 'A16',
  }

  COUNTRIES = {
    #'AL': '10YAL-KESH-----5',
    'AT': '10YAT-APG------L',
    #'AX': '10Y1001A1001A46L',  # for price only; Åland has SE-SE3 area price
    'BA': '10YBA-JPCC-----D',
    'BE': '10YBE----------2',
    'BG': '10YCA-BULGARIA-R',
    #'BY': '10Y1001A1001A51S',
    'CH': '10YCH-SWISSGRIDZ',
    'CZ': '10YCZ-CEPS-----N',
    'DE': '10Y1001A1001A83F',
    'DE-LU': '10Y1001A1001A82H', # duplicate of DE
    'DK': '10Y1001A1001A65H',
    'DK-DK1': '10YDK-1--------W',
    'DK-DK2': '10YDK-2--------M',
    'EE': '10Y1001A1001A39I',
    'ES': '10YES-REE------0',
    'FI': '10YFI-1--------U',
    'FR': '10YFR-RTE------C',
    'GB': '10YGB----------A', # exited dataset in 2021
    #'GB-NIR': '10Y1001A1001A016',
    'GR': '10YGR-HTSO-----Y',
    'HR': '10YHR-HEP------M',
    'HU': '10YHU-MAVIR----U',
    'IE': '10YIE-1001A00010',
    'IT': '10YIT-GRTN-----B',
    #'IT-BR': '10Y1001A1001A699',
    #'IT-CA': '10Y1001C--00096J',
    #'IT-CNO': '10Y1001A1001A70O',
    #'IT-CSO': '10Y1001A1001A71M',
    #'IT-FO': '10Y1001A1001A72K',
    #'IT-NO': '10Y1001A1001A73I',
    #'IT-PR': '10Y1001A1001A76C',
    #'IT-SAR': '10Y1001A1001A74G',
    #'IT-SIC': '10Y1001A1001A75E',
    #'IT-SO': '10Y1001A1001A788',
    'LT': '10YLT-1001A0008Q',
    'LU': '10YLU-CEGEDEL-NQ',
    'LV': '10YLV-1001A00074',
    # 'MD': 'MD',
    'ME': '10YCS-CG-TSO---S',
    'MK': '10YMK-MEPSO----8', # has bad load data
    #'MT': '10Y1001A1001A93C',
    'NL': '10YNL----------L',
    'NO': '10YNO-0--------C',
    'NO-NO1': '10YNO-1--------2',
    'NO-NO2': '10YNO-2--------T',
    'NO-NO3': '10YNO-3--------J',
    'NO-NO4': '10YNO-4--------9',
    'NO-NO5': '10Y1001A1001A48H',
    'PL': '10YPL-AREA-----S',
    'PT': '10YPT-REN------W',
    'RO': '10YRO-TEL------P',
    'RS': '10YCS-SERBIATSOV',
    #'RU': '10Y1001A1001A49F',
    #'RU-KGD': '10Y1001A1001A50U',
    'SE': '10YSE-1--------K',
    'SE-SE1': '10Y1001A1001A44P',
    'SE-SE2': '10Y1001A1001A45N',
    'SE-SE3': '10Y1001A1001A46L',
    'SE-SE4': '10Y1001A1001A47J',
    'SI': '10YSI-ELES-----O',
    'SK': '10YSK-SEPS-----K',
    #'TR': '10YTR-TEIAS----W',
    #'UA': '10YUA-WEPS-----0',
    'XK': '10Y1001C--00100H'
  }
  PARAMETER_DESC = {
    'B01': 'Biomass',
    'B02': 'Fossil Brown coal/Lignite',
    'B03': 'Fossil Coal-derived gas',
    'B04': 'Fossil Gas',
    'B05': 'Fossil Hard coal',
    'B06': 'Fossil Oil',
    'B07': 'Fossil Oil shale',
    'B08': 'Fossil Peat',
    'B09': 'Geothermal',
    'B10': 'Hydro Pumped Storage',
    'B11': 'Hydro Run-of-river and poundage',
    'B12': 'Hydro Water Reservoir',
    'B13': 'Marine',
    'B14': 'Nuclear',
    'B15': 'Other renewable',
    'B16': 'Solar',
    'B17': 'Waste',
    'B18': 'Wind Offshore',
    'B19': 'Wind Onshore',
    'B20': 'Other',
  }
  DOMAIN_MAPPINGS = COUNTRIES

  def inspect
    "#<ENTSO-E>"
  end
end
