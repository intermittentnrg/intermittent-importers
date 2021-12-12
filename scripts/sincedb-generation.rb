#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'
require 'yaml'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

SOURCE = ENTSOE::Generation
OUT_SERIES = 'entsoe_generation'

logger = SemanticLogger['sincedb-generation.rb']

ENTSOE::COUNTRIES.keys.each do |country|
logger.tagged(country: country) do
  r = influxdb.query("SELECT time,LAST(value) FROM #{OUT_SERIES} WHERE country = %{1}", params: [country])
  from = DateTime.parse r[0]['values'][0]['time']
  to = [from + 1.months, DateTime.now.beginning_of_hour].min
  if from > 2.hours.ago
    logger.info "up to date"
    next
  end
  logger.measure_info "Load #{from} to #{to}" do
  begin
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
    logger.info "#{data.length} points"
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
end
end
