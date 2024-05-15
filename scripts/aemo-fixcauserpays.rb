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

# Let UPDATE in progress finish on ctrl-c
$lock = false
$exiting = false
trap("SIGINT") do
  abort if !$lock || $exiting
  $stderr.puts "Exiting after chunk finishes"
  $exiting = true
end

(_from..._to).each do |from|
  to = from + 1.day

  # Select chunks for the current date range
  chunks = conn.select_values <<~SQL
    SELECT gbad.tableoid::regclass FROM generation_unit_hires gbad
    INNER JOIN units ubad ON(unit_id=ubad.id)
    INNER JOIN units ugood ON(ubad.internal_id=ugood.hires_internal_id)
    WHERE
      ubad.area_id=338 AND
      ubad.hires_internal_id IS NULL AND
      time >= '#{from}' AND time < '#{to}'
    GROUP BY tableoid
  SQL
  next if chunks.empty?

  # Decompress chunks
  chunks.each do |chunk|
    conn.execute "SELECT decompress_chunk('#{chunk}', true)"
  rescue ActiveRecord::Deadlocked
    puts $!.inspect
    retry
  end

  # Update data
  $lock = true
  begin
    conn.execute <<~SQL
      UPDATE generation_unit_hires gbad
      SET unit_id=ugood.id
      FROM
        units ubad,
        units ugood
      WHERE
        gbad.unit_id=ubad.id AND
        ubad.internal_id=ugood.hires_internal_id AND
        ubad.area_id=338 AND
        ubad.hires_internal_id IS NULL AND
        time >= '#{from}' AND time < '#{to}'
    SQL
  rescue ActiveRecord::RecordNotUnique
    puts $!.inspect
    conn.execute <<~SQL
      DELETE FROM
        generation_unit_hires gbad
      USING
        units ubad,
        units ugood,
        generation_unit_hires ggood
      WHERE
        gbad.unit_id=ubad.id AND
        ubad.hires_internal_id IS NULL AND
        ubad.area_id=338 AND
        ubad.internal_id=ugood.hires_internal_id AND
        ugood.id=ggood.unit_id AND
        gbad.time = ggood.time AND
        gbad.time >= '#{from}' AND gbad.time < '#{to}' AND
        ggood.time >= '#{from}' AND ggood.time < '#{to}' AND
        gbad.value = ggood.value
    SQL
    retry
  end

  # Compress chunks
  chunks.each do |chunk|
    conn.execute "SELECT compress_chunk('#{chunk}', true)"
  end
  break if $exiting
  $lock = false
end
#binding.irb

# Re-enable automatic compression job
conn.execute "SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = 'generation_unit_hires'), scheduled => true)"
