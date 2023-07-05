# coding: utf-8
require 'date'
require 'httparty'
require 'rexml/document'
require 'active_support'
require 'active_support/core_ext'

module Elexon
  class Base
    def self.source_id
      "elexon"
    end

    def initialize(date)
      @from = date + 30.minutes
      @to = date.tomorrow + 30.minutes
      @options = {}
      @options[:ServiceType] = 'xml'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      @options[:Period] = '*'
      @options[:SettlementDate] = date.strftime('%Y-%m-%d')
      fetch
    end
    def fetch
      url = "https://api.bmreports.com/BMRS/#{@report}/v1"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: @options,
          #debug_output: $stdout
        )
      end
      error_type = @res.parsed_response['response']['responseMetadata']['errorType']
      raise error_type if @res.parsed_response['response'].try(:[], 'responseBody').empty?
    end
  end

  class FuelInst < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(from, to)
      @from = from
      @to = to
      @report = 'FUELINST'
      @options = {}
      @options[:FromDateTime] = Time.parse(from).strftime('%Y-%m-%d %H:%M:%S')
      @options[:ToDateTime] = Time.parse(to).strftime('%Y-%m-%d %H:%M:%S')
      @options[:Period] = "*"
      @options[:ServiceType] = 'xml'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      fetch
    end
    def points_generation
      r = {}
      @res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
        time = (Time.strptime("#{item['startTimeOfHalfHrPeriod']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes)

        r[time] = r2 = []
        r2 << {
          country: 'GB_fuelinst',
          production_type: 'wind',
          time: time,
          value: item['wind'].to_f
        }
      end
      #require 'pry' ; binding.pry

      r.values.flatten
    end
  end

  class WindSolar < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @report = 'B1630'
      super
    end
    def points
      r = {}
      @res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
        time = (Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes)
        production_type = item['powerSystemResourceType'].gsub(/"/,'').downcase.tr_s(' ', '_')
        key = "#{time}-#{production_type}"
        if r[key]
          next
        end
        r[key] = {
          country: 'GB_B1630',
          production_type: production_type,
          time: time,
          value: item['quantity'].to_f
        }
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @report = 'B1620'
      super
    end
    def points_generation
      r = {}
      @res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
        time = (Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes)
        production_type = item['powerSystemResourceType'].gsub(/"/,'').downcase.tr_s(' ', '_')
        key = "#{time}-#{production_type}"
        if r[key]
          next
        end
        r[key] = {
          country: 'GB',
          production_type: production_type,
          time: time,
          value: item['quantity'].to_f
        }
      end

      r.values
    end
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    def initialize(date)
      @report = 'B0610'
      super
    end
    def points_load
      r = {}
      @res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
        time = Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes
        value = item['quantity'].to_i
        next if value < 10000
        if r[time]
          next
        end

        r[time] = {
          time: time,
          country: 'GB',
          value: value
        }
      end
      #r.filter! { |r2| r2[:value] > 10000 }
      #require 'pry' ; binding.pry

      r.values
    end
  end
end
