#!/usr/bin/env ruby
require 'bundler/setup'
require 'dotenv/load'
require 'date'
require 'fastest-csv'

require 'pp'

BATCH_SIZE = 10_000

require 'influxdb'
async_options = {
  # number of points to write to the server at once
  max_post_points:     BATCH_SIZE,
  # queue capacity
  max_queue_size:      BATCH_SIZE,
  # number of threads
  num_worker_threads:  1,
  # max. time (in seconds) a thread sleeps before
  # checking if there are new jobs in the queue
  sleep_interval:      1,
  # whether client will block if queue is full
  block_on_full_queue: true,
  # Max time (in seconds) the main thread will wait for worker threads to stop
  # on shutdown. Defaults to 2x sleep_interval.
  shutdown_timeout: 10
}
influxdb = InfluxDB::Client.new url: ENV['INFLUXDB_URL'], time_precision: "ms", async: async_options

influxdb.create_retention_policy('1d', 'intermittency', '0s', '1', false, shard_duration: '1d')

if ARGV.length == 0
  $stderr.puts "${$0} <csv>"
  exit 1
end

ARGV.each do |file|
  $stderr.write "\n#{file}"
  FastestCSV.open(file) do |csv|
    csv.shift
    csv.each_slice(BATCH_SIZE) do |slice|
      data = slice.map do |row|
        time = InfluxDB.convert_timestamp(DateTime.parse(row[0]).to_time, 'ms')
        {
          series: 'fingrid_frequency',
          values: { value: row[1].to_f },
          timestamp: time
        }
      end
      #pp data
      influxdb.write_points(data, 'ms', '1d')
      $stderr.write '.'
    end
  end
end
