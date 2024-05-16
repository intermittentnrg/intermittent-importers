class Generation < ActiveRecord::Base
  include SemanticLogger::Loggable
  self.table_name = 'generation_data'
  acts_as_hypertable time_column: 'time'
  belongs_to :areas_production_type

  def self.enable_compression_policy!
    connection.execute <<~SQL
      SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = '#{self.table_name}'), scheduled => true);
    SQL
  end
  def self.disable_compression_policy!
    connection.execute <<~SQL
      SELECT alter_job((SELECT job_id FROM timescaledb_information.jobs WHERE proc_name='policy_compression' AND hypertable_name = '#{self.table_name}'), scheduled => false);
    SQL
  end

  def self.aggregate_to_capture(from, to, where)
    logger.benchmark_info("aggregate_to_capture") do
      from = from.beginning_of_hour
      if to.min != 0
        to = to.beginning_of_hour + 1.hour
      end
      r = connection.exec_query <<-SQL
        INSERT INTO generation_capture (
          time,
          area_id,
          production_type_id,
          price,

          kwh,
          kwh_generated,
          kwh_consumed,

          revenue,
          revenue_generated,
          revenue_consumed
        )
        -- Calculate kWh
        SELECT
          time_bucket('1h',g.time) AS time,
          g.area_id,
          g.production_type_id,
          AVG(p.value) AS price,

          AVG(g.value) AS kwh,
          AVG(GREATEST(0,g.value)) AS kwh_generated,
          AVG(LEAST(0,g.value)) AS kwh_consumed,

          -- price per mwh / kwh !!
          AVG(p.value::bigint*g.value)/1000 AS revenue,
          AVG(p.value::bigint*GREATEST(0,g.value))/1000 AS revenue_generated,
          AVG(p.value::bigint*LEAST(0,g.value))/1000 AS revenue_consumed
        FROM generation g
        INNER JOIN prices p ON(g.area_id=p.area_id AND g.time=p.time)
        -- Joins for WHERE clause
        INNER JOIN areas a ON(g.area_id=a.id)
        INNER JOIN production_types pt ON(g.production_type_id=pt.id)
        WHERE
          a.source='aemo' AND
          pt.name <> 'solar_rooftop' AND
          pt.name NOT LIKE 'battery%' AND
          pt.name NOT LIKE 'hydro%' AND
          g.time BETWEEN '#{from}' AND '#{to}' AND #{where}
        GROUP BY 1,2,3
        ON CONFLICT (area_id, production_type_id, time) DO UPDATE SET
          price = EXCLUDED.price,
          kwh = EXCLUDED.kwh,
          kwh_generated = EXCLUDED.kwh_generated,
          kwh_consumed = EXCLUDED.kwh_consumed,
          revenue = EXCLUDED.revenue,
          revenue_generated = EXCLUDED.revenue_generated,
          revenue_consumed = EXCLUDED.revenue_consumed
      SQL
    end
  end

  def self.aggregate_rooftoppv_to_capture(from, to, where)
    logger.benchmark_info("aggregate_to_capture") do
      from = from.beginning_of_hour
      if to.min != 0
        to = to.beginning_of_hour + 1.hour
      end
      r = connection.exec_query <<-SQL
        INSERT INTO generation_capture (
          time,
          area_id,
          production_type_id,
          price,

          kwh,
          kwh_generated,
          kwh_consumed,

          revenue,
          revenue_generated,
          revenue_consumed
        )
        -- Calculate kWh
        SELECT
          time_bucket('1h',g.time) AS time,
          g.area_id,
          g.production_type_id,
          AVG(p.value) AS price,

          AVG(g.value) AS kwh,
          AVG(GREATEST(0,g.value)) AS kwh_generated,
          AVG(LEAST(0,g.value)) AS kwh_consumed,

          -- price per mwh / kwh !!
          AVG(p.value::bigint*g.value)/1000 AS revenue,
          AVG(p.value::bigint*GREATEST(0,g.value))/1000 AS revenue_generated,
          AVG(p.value::bigint*LEAST(0,g.value))/1000 AS revenue_consumed
        FROM (
          -- INTERPOLATE rooftop_pv to 5minute to match prices
          SELECT
            time_bucket_gapfill('5m', g.time) AS time,
            g.area_id,
            g.production_type_id,
            INTERPOLATE(AVG(g.value)) AS value
          FROM generation g
          -- Joins for WHERE clause
          INNER JOIN areas a ON(g.area_id=a.id)
          INNER JOIN production_types pt ON(g.production_type_id=pt.id)
          WHERE
            a.source='aemo' AND
            pt.name = 'solar_rooftop' AND
            g.time BETWEEN '#{from}' AND '#{to}' AND #{where}
          GROUP BY 1,2,3
        ) g
        INNER JOIN prices p ON(g.area_id=p.area_id AND g.time=p.time)
        WHERE g.value IS NOT NULL
        GROUP BY 1,2,3
        ON CONFLICT (area_id, production_type_id, time) DO UPDATE SET
          price = EXCLUDED.price,
          kwh = EXCLUDED.kwh,
          kwh_generated = EXCLUDED.kwh_generated,
          kwh_consumed = EXCLUDED.kwh_consumed,
          revenue = EXCLUDED.revenue,
          revenue_generated = EXCLUDED.revenue_generated,
          revenue_consumed = EXCLUDED.revenue_consumed
      SQL
    end
  end
end
