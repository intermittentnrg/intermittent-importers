class Transmission < ActiveRecord::Base
  self.table_name = 'transmission_data'
  acts_as_hypertable time_column: 'time'
  #belongs_to :from_area, class_name: 'Area'
  #belongs_to :to_area, class_name: 'Area'
  belongs_to :areas_area
  #delegate :from_area, :to => :areas_area
  #delegate :to_area, :to => :areas_area
  #has_one :from_area, through: :areas_area
  #has_one :to_area, through: :areas_area

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
end
