#!/usr/bin/env ruby
require 'bundler/setup'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true,
                                chunk_size: 10000

require './lib/activerecord-connect'

influxdb.query('SELECT * FROM entsoe_generation WHERE time > \'2020-01-01T00:00:00Z\'') do |name, tags, values|
  $stderr.print "_"
  #require 'pry' ; binding.pry
  values.each do |v|
    v['created_at'] = v.delete 'time'
    v['updated_at'] = Time.now.to_s
  end
  EntsoeGeneration.insert_all values
  #values.each do |row|
  #  EntsoeGeneration.create(
  #    created_at: row['time'],
  #    country: row['country'],
  #    process_type: row['process_type'],
  #    production_type: row['production_type'],
  #    value: row['value']
  #  )
  #  $stderr.print "."
  #end
end
puts "Done!"
