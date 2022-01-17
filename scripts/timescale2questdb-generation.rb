#!/usr/bin/env ruby
require 'bundler/setup'
require 'dotenv/load'

require './lib/activerecord-connect'

require './app/models/entsoe_generation'
require './app/models/questdb_generation'

$stderr.puts "Running query..."
connection = ActiveRecord::Base.connection.raw_connection
r = connection.send_query <<-SQL
SELECT
  time_bucket('1h',time) AS "time",
  country,
  production_type::text,
  avg(value) AS "value"
FROM entsoe_generation
WHERE
  time > '2014-01-01T00:00:00Z' AND
  LENGTH(country)=2 AND
  country<>'GB'
GROUP BY 1,2,3

UNION ALL

SELECT
  time_bucket('1h',time) AS "time",
  'GB' AS "country",
  production_type,
  avg(value) AS "value"
FROM elexon_generation
WHERE
  time > '2014-01-01T00:00:00Z' AND
  production_type::text LIKE 'wind_%'
GROUP BY 1,2,3
ORDER BY 1,2,3
SQL

connection.set_single_row_mode
result = connection.get_result
#require 'pry' ;binding.pry

$stderr.puts "Truncating target table..."
QuestdbGeneration.connection.exec_query("TRUNCATE TABLE generation")
# CREATE TABLE generation(time TIMESTAMP, country SYMBOL index, production_type SYMBOL index, value INT) timestamp(time);

#r.each do |row|

$stderr.write "Writing data"
result.stream_each.each_slice(10000) do |rows|
  sql = "INSERT INTO generation(time,country,production_type,value)\n"
  sql += "VALUES\n"
  rows.map! do |row|
    "(#{row['time'].strftime('%s%6N')}, '#{row['country']}', '#{row['production_type']}', #{row['value']})"
  end
  sql += rows.join ",\n"
  QuestdbGeneration.connection.exec_query(sql)

  $stderr.write "."
end
