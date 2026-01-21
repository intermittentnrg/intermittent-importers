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
    raise unless where.include? 'source'

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
          #{where}
        GROUP BY 1,2
        ON CONFLICT (areas_production_type_id, time)
          DO UPDATE set value = EXCLUDED.value WHERE generation_data.value<>EXCLUDED.value
      SQL
      r = connection.execute sql
      logger.info "#{r.cmd_tuples} rows affected"

      r
    rescue ActiveRecord::NotNullViolation
      sql = <<~SQL
        SELECT
          DISTINCT area_id, production_type_id, pt.name
        FROM generation_unit g
        INNER JOIN units u ON(unit_id=u.id)
        INNER JOIN areas A ON(area_id=a.id)
        INNER JOIN production_types pt ON (production_type_id=pt.id)
        LEFT JOIN areas_production_types apt USING(area_id, production_type_id)
        WHERE
          apt.id IS NULL AND
          g.time >= '#{from}' AND g.time < '#{to}' AND
          #{where}
      SQL
      # require 'pry' ; binding.pry
      r = connection.execute sql
      r.each do |row|
        logger.warn("Created new apt for area_id #{row['area_id']} pt #{row['name']}")
        AreasProductionType.create!(area_id: row['area_id'], source_area_id: row['area_id'], production_type_id: row['production_type_id'])
      end
      retry
    end
    Generation.aggregate_to_capture(from, to, where)
  end
end
