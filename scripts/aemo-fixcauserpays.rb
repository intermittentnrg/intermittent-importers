#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
require 'chronic'

ActiveRecord::Base.logger = Logger.new(STDOUT)
conn = ActiveRecord::Base.connection

_from=Chronic.parse(ARGV.shift).to_date
_to=Chronic.parse(ARGV.shift).to_date

# Disable automatic compression job
conn.execute "SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = 'generation_unit_hires'), scheduled => false)"

$lock = false
$exiting = false
trap("SIGINT") do
  throw :ctrl_c if !$lock || $exiting
  $exiting = true
end
chunks = []
(_from.._to).each do |from|
  to = from + 1.day

  # Select chunks for the current date range
  chunks = conn.select_values <<~SQL
    SELECT g.tableoid::regclass FROM generation_unit_hires g
    INNER JOIN units u ON(unit_id=u.id)
    INNER JOIN units uh ON(u.internal_id=uh.hires_internal_id)
    WHERE
      u.area_id=338 AND
      time >= '#{from}' AND time < '#{to}'
    GROUP BY tableoid;
  SQL
  next if chunks.empty?

  # Decompress chunks
  chunks.each do |chunk|
    conn.execute "SELECT decompress_chunk('#{chunk}', true);"
  rescue ActiveRecord::Deadlocked
    puts $!.inspect
    retry
  end

  $lock = true
  conn.execute <<~SQL
    UPDATE generation_unit_hires g
    SET unit_id=uh.id
    FROM
      units u,
      units uh
    WHERE
      unit_id=u.id AND
      u.internal_id=uh.hires_internal_id AND
      u.area_id=338 AND
      time >= '#{from}' AND time < '#{to}'
  SQL

  # Compress chunks
  chunks.each do |chunk|
    conn.execute "SELECT compress_chunk('#{chunk}', true);"
  end
  $lock = false
end
#binding.irb

# Re-enable automatic compression job
conn.execute "SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = 'generation_unit_hires'), scheduled => true)"
