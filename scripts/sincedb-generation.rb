#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'
require 'yaml'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

SOURCE = ENTSOE::Generation
OUT_SERIES = 'entsoe_generation'


ENTSOE::COUNTRIES.keys.each do |country|
  r = influxdb.query("SELECT time,LAST(value) FROM #{OUT_SERIES} WHERE country = %{1}", params: [country])
  from = DateTime.parse r[0]['values'][0]['time']
  to = [from + 1.months, DateTime.now.beginning_of_hour].min
  if from > 2.hours.ago
    $stderr.puts "#{country} up to date"
    next
  end
  begin
    $stderr.puts "#{country} #{from} to #{to}"
    e = SOURCE.new(country: country, from: from, to: to)
    #puts e.points
    data = e.points.map do |p|
      {
        series: OUT_SERIES,
        values: { value: p[:value] },
        tags:   { country: p[:country], production_type: p[:production_type], process_type: p[:process_type] },
        timestamp: p[:timestamp].to_i
      }
    end
    influxdb.write_points(data)
    puts "#{data.length} points"
  rescue ENTSOE::EmptyError
    if to > 1.day.ago
      puts "Error during processing: #{$!}"
      puts "Backtrace:\n\t#{$!.backtrace.join("\n\t")}"
      next
    end

    # skip missing historical data
    $stderr.puts "skipped missing data until #{to}"
  end
end
