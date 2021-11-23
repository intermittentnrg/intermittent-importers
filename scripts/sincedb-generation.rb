#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'
require './lib/entsoe/state'
require 'yaml'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

STATE_FILE = 'sincedb-generation.yaml'
SOURCE = ENTSOE::Generation
OUT_SERIES = 'entsoe_generation'

@state = ENTSOE::State.new STATE_FILE

#.select { |k| k.match /^DK/ }

ENTSOE::COUNTRIES.keys.each do |country|
  next if country == :GB
  from = @state[country]
  to = [from + 1.months, DateTime.now.beginning_of_hour].min
  if from > 4.hours.ago
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
    @state[country] = e.last_time
  rescue ENTSOE::EmptyError
    if to > 1.day.ago
      puts "Error during processing: #{$!}"
      puts "Backtrace:\n\t#{$!.backtrace.join("\n\t")}"
      next
    end

    # skip missing historical data
    @state[country] = to
    $stderr.puts "skipped missing data until #{to}"
  ensure
    @state.save!
  end
end
