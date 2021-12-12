#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'
require 'yaml'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

SOURCE = ENTSOE::WindSolar
OUT_SERIES = 'entsoe_windsolar'

pass = false
loop do
  pass = false
  #.select { |k| k.match /^DK/ }
  ENTSOE::COUNTRIES.keys.each do |country|
    r = influxdb.query("SELECT time,LAST(value) FROM #{OUT_SERIES} WHERE country = %{1}", params: [country])
    from = DateTime.parse r[0]['values'][0]['time']
    to = [from + 5.months, DateTime.now.beginning_of_hour].min
    begin
      $stderr.puts "#{country} #{from} to #{to}"
      e = SOURCE.new(country: country, from: from, to: to)
      data = e.points.map do |p|
        {
          series: OUT_SERIES,
          values: { value: p[:value] },
          tags:   { country: p[:country] },
          timestamp: p[:timestamp].to_i
        }
      end
      influxdb.write_points(data)
      puts "#{data.length} points"
      pass = true
    rescue ENTSOE::EmptyError
      #require 'pry' ;binding.pry
      raise if to < 1.day.ago

      # skip missing historical data
      logger.warn "skipped missing data until #{to}"
    end
  end
  break unless pass
end
