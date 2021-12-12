#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'
require 'yaml'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

SOURCE = ENTSOE::Load
OUT_SERIES = 'entsoe_load'

pass = false
loop do
  pass = false
  #.select { |k| k.match /^DK/ }
  ENTSOE::DOMAIN_MAPPINGS.keys.each do |country|
    r = influxdb.query("SELECT time,LAST(value) FROM #{OUT_SERIES} WHERE country = %{1}", params: [country])
    from = DateTime.parse r[0]['values'][0]['time']
    to = [from + 5.months, DateTime.now.beginning_of_hour].min
    if from > 4.hours.ago
      $stderr.puts "#{country} up to date"
      next
    end
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
      $stderr.puts "skipped missing data until #{to}"
    end
  end
  break unless pass
  $stderr.puts "===== LOOP ====="
end
