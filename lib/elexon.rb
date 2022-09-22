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
      @options = {}
      @options[:ServiceType] = 'xml'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      @options[:Period] = '*'
      @options[:SettlementDate] = date.strftime('%Y-%m-%d')
      fetch
    end
    def fetch
      @res = HTTParty.get(
        "https://api.bmreports.com/BMRS/#{@report}/v1",
        query: @options,
        #debug_output: $stdout
      )
    end
  end

  class Generation < Base
    def initialize(date)
      @report = 'B1620'
      super
    end
    def points
      r = []
      @res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
        r << {
          country: 'GB',
          production_type: item['powerSystemResourceType'].gsub(/"/,'').downcase.tr_s(' ', '_'),
          time: DateTime.strptime(item['settlementDate'], '%Y-%m-%d') + (item['settlementPeriod'].to_i * 30).minutes,
          value: item['quantity'].to_i
        }
      end

      r
    end
  end

  class Load < Base
    def initialize(date)
      @report = 'B0610'
      super
    end
    def points
      r = {}
      @res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
        time = DateTime.strptime(item['settlementDate'], '%Y-%m-%d') + (item['settlementPeriod'].to_i * 30).minutes
        value = item['quantity'].to_i
        next if value < 10000
        if r[time]
          require 'pry' ; binding.pry
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
