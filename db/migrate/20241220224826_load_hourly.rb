class LoadHourly < ActiveRecord::Migration[7.1]
  def change
    query = <<-SQL
SELECT
  time_bucket('1h', time) AS time,
  area_id,
  AVG(value) AS value
FROM load l
GROUP BY 1,2
SQL

    options = {
      with_data: false,
      refresh_policies: {
        start_offset: 'NULL',
        #start_offset: "INTERVAL '1 year'",
        end_offset: "INTERVAL '1 day'",
        schedule_interval: "INTERVAL '1 hour'"
      },
      create_group_indexes: false
    }
    reversible do |dir|
      dir.up do
        create_continuous_aggregate(:load_hourly, query, **options)
        execute <<-SQL
SELECT set_chunk_time_interval(
  (SELECT
    format('%I.%I', materialization_hypertable_schema, materialization_hypertable_name)
  FROM timescaledb_information.continuous_aggregates
  WHERE
    view_name = 'load_hourly'
  ), INTERVAL '1 year');
SQL
        #execute "ALTER MATERIALIZED VIEW load_hourly SET (timescaledb.compress = true)"
        #execute "SELECT add_compression_policy('load_hourly', INTERVAL '1 year')"

        #execute "CALL refresh_continuous_aggregate('load_hourly', NULL, localtimestamp - INTERVAL '1 day')"
      end
      dir.down do
        drop_continuous_aggregates(:load_hourly)
      end
    end
  end
end
