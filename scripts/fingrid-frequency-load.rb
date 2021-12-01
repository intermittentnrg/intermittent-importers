#!/usr/bin/env ruby
require 'bundler/setup'
require 'dotenv/load'
require 'date'
require 'csv'

require 'pp'

require 'influxdb'
influxdb = InfluxDB::Client.new url: ENV['INFLUXDB_URL'], time_precision: "ms", async: true

influxdb.create_retention_policy('1d', 'intermittency', '0s', '1', false, shard_duration: '1d')

if ARGV.length == 0
  $stderr.puts "${$0} <csv>"
  exit 1
end

ARGV.each do |file|
  $stderr.write "\n#{file}"
  CSV.foreach(file, headers: true).each_slice(1000) do |slice|
    data = slice.map do |row|
      time = InfluxDB.convert_timestamp(DateTime.parse(row['Time']).to_time, 'ms')
      {
        series: 'fingrid_frequency',
        values: { value: row["Value"].to_f },
        timestamp: time
      }
    end
    #pp data
    influxdb.write_points(data, 'ms', '1d')
    $stderr.write '.'
  end
end
