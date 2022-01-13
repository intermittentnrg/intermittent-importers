#!/usr/bin/env ruby
require 'bundler/setup'

require 'date'
require 'httparty'
require 'active_support'
require 'active_support/core_ext'


class SvkControlroomParser
  NAMES = {
    2 => 'nuclear',
    4 => 'thermal',
    5 => 'wind',
    6 => 'unknown',
    1 => 'production',
    7 => 'consumption',
    3 => 'hydro'
  }

  def initialize date
    @options = {
      productionDate: date.strftime('%Y-%m-%d'),
      countryCode: 'SE'
    }
    @r = HTTParty.get(
      'https://www.svk.se/ControlRoom/GetProductionHistory/',
      query: @options,
      #debug_output: $stdout
    )
  end

  def points
    r = []
    @r.each do |row|
      type = NAMES[row['name']]
      row['data'].each do |point|
        r << {
          time: Time.at(point['x']/1000),
          production_type: type,
          value: point['y']
        }
      end
    end

    r
  end
end
