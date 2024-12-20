class GenerationDataHourly < ActiveRecord::Migration[7.1]
  def change
    query = <<-SQL
SELECT
  time_bucket('1h', time) AS time,
  areas_production_type_id,
  AVG(value) AS value
FROM generation_data g
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
        create_continuous_aggregate(:generation_data_hourly, query, **options)
        execute <<-SQL
SELECT set_chunk_time_interval(
  (SELECT
    format('%I.%I', materialization_hypertable_schema, materialization_hypertable_name)
  FROM timescaledb_information.continuous_aggregates
  WHERE
    view_name = 'generation_data_hourly'
  ), INTERVAL '1 year');
SQL
        #execute "ALTER MATERIALIZED VIEW generation_data_hourly SET (timescaledb.compress = true)"
        #execute "SELECT add_compression_policy('generation_data_hourly', INTERVAL '1 year')"

        #execute "CALL refresh_continuous_aggregate('generation_data_hourly', NULL, localtimestamp - INTERVAL '1 day')"
      end
      dir.down do
        drop_continuous_aggregates(:generation_data_hourly)
      end
    end
  end
end
