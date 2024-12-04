#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
ActiveRecord::Base.logger = Logger.new(STDOUT)

conn = ActiveRecord::Base.connection

# Disable automatic compression job
conn.execute "SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = 'transmission'), scheduled => false)"

Transmission.chunks.order(:range_start).each do |chunk|
  #require 'pry' ; binding.pry
  conn.execute "SELECT decompress_chunk('#{chunk.chunk_schema}.#{chunk.chunk_name}', true)"

  sql_subquery = <<-SQL
UPDATE transmission t
SET areas_area_id=(SELECT id FROM areas_areas aa WHERE t.from_area_id=aa.from_area_id AND t.to_area_id=aa.to_area_id)
WHERE
  time BETWEEN '#{chunk.range_start}' AND '#{chunk.range_end}' AND
  areas_area_id IS NULL
SQL

  sql_join = <<-SQL
UPDATE transmission t
SET areas_area_id=aa.id
FROM areas_areas aa
WHERE
  time BETWEEN '#{chunk.range_start}' AND '#{chunk.range_end}' AND
  t.from_area_id=aa.from_area_id AND
  t.to_area_id=aa.to_area_id AND
  areas_area_id IS NULL
SQL
  conn.execute sql_join

  conn.execute "SELECT compress_chunk('#{chunk.chunk_schema}.#{chunk.chunk_name}', true)"
  puts
end

# Re-enable automatic compression job
conn.execute "SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = 'transmission'), scheduled => true)"
