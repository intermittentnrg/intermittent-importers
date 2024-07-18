class GenerationUnit < ActiveRecord::Base
  include SemanticLogger::Loggable
  self.table_name = 'generation_unit'
  acts_as_hypertable time_column: 'time'
  belongs_to :unit

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

  def self.aggregate_to_generation(from, to, where)

    logger.benchmark_info("aggregate_to_generation #{from} #{to}") do
      sql = <<~SQL
        INSERT INTO generation_data (areas_production_type_id, time, value)
        SELECT
          apt.id AS areas_production_type_id,
          time,
          SUM(value) AS value
        FROM generation_unit g
        INNER JOIN units u ON(unit_id=u.id)
        INNER JOIN areas a ON(u.area_id=a.id)
        LEFT JOIN areas_production_types apt ON(u.area_id=apt.area_id AND u.production_type_id=apt.production_type_id)
        WHERE
          g.time >= '#{from}' AND g.time < '#{to}' AND
          a.source='aemo' AND
          #{where}
        GROUP BY 1,2
        HAVING NOT EXISTS (
          SELECT 1 FROM generation_data g2
          WHERE apt.id=g2.areas_production_type_id AND time=g2.time AND value=g2.value AND
                g2.time >= '#{from}' AND g2.time < '#{to}'
        )
        ON CONFLICT (areas_production_type_id, time)
          DO UPDATE set value = EXCLUDED.value WHERE generation_data.value<>EXCLUDED.value
      SQL
      r = connection.execute sql
      logger.info "#{r.cmd_tuples} rows affected"

      r
    end
    Generation.aggregate_to_capture(from, to, where)
  end
end
