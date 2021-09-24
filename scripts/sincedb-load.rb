#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'
require './lib/entsoe/state'
require 'yaml'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

@state = ENTSOE::State.new 'sincedb-load.yaml'
pass = false
loop do
  pass = false
  #.select { |k| k.match /^DK/ }
  ENTSOE::DOMAIN_MAPPINGS.keys.each do |country|
    next if country == :GB
    from = @state[country]
    to = [from + 5.months, DateTime.now.beginning_of_hour].min
    if from > 4.hours.ago
      $stderr.puts "#{country} up to date"
      next
    end
    begin
      $stderr.puts "#{country} #{from} to #{to}"
      e = ENTSOE::Load.new(country: country, from: from, to: to)
      data = e.points.map do |p|
        {
          series: 'entsoe_load',
          values: { value: p[:value] },
          tags:   { country: p[:country] },
          timestamp: p[:timestamp].to_i
        }
      end
      influxdb.write_points(data)
      puts "#{data.length} points"
      pass = true
      @state[country] = e.last_time
    rescue ENTSOE::EmptyError
      #require 'pry' ;binding.pry
      raise if to < 1.day.ago

      # skip missing historical data
      @state[country] = to
      $stderr.puts "skipped missing data until #{to}"
    ensure
      @state.save!
    end
  end
  break unless pass
  $stderr.puts "===== LOOP ====="
end
