class Load < ActiveRecord::Base
  self.table_name = 'load'
  acts_as_hypertable time_column: 'time'
  belongs_to :area

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

  def inspect
    if value > 1000000
      s = "#{value/1000000.0} GW"
    elsif value > 1000
      s = "#{value/1000.0} MW"
    else
      s = "#{value} kW"
    end
    "#<Load area_id: #{area_id} time: #{time} value: #{s}>"
  end
end
