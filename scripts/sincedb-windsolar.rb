#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-windsolar.rb']

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

SOURCE = ENTSOE::WindSolar
OUT_SERIES = 'entsoe_windsolar'

require './lib/pump'
Pump.new(SOURCE, OUT_SERIES, influxdb).run
return

pass = false
loop do
  pass = false
  SOURCE::COUNTRIES.keys.each do |country|
    logger.tagged(country: country) do
      r = influxdb.query("SELECT time,LAST(value) FROM #{OUT_SERIES} WHERE country = %{1}", params: [country])
      from = DateTime.parse r[0]['values'][0]['time']
      to = [from + 5.months, DateTime.now.beginning_of_hour].min
      if from > 4.hours.ago
        logger.info "up to date"
        next
      end
      logger.measure_info "Load #{from} to #{to}" do
        begin
          e = SOURCE.new(country: country, from: from, to: to)
          data = e.points.map do |p|
            {
              series:    OUT_SERIES,
              values:    { value: p[:value] },
              tags:      p[:tags],
              timestamp: p[:timestamp].to_i
            }
          end
          influxdb.write_points(data)
          logger.info "#{data.length} points"
          pass = true if data.length>1
        rescue ENTSOE::EmptyError
          #require 'pry' ;binding.pry
          raise if to < 1.day.ago

          # skip missing historical data
          logger.warn "skipped missing data until #{to}"
        end
      end
    end
  end
  break unless pass
  $stderr.puts "===== LOOP ====="
end
