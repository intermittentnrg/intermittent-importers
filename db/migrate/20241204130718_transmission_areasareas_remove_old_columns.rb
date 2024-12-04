class TransmissionAreasareasRemoveOldColumns < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
ALTER TABLE transmission_data
  ALTER COLUMN areas_area_id SET NOT NULL,
  DROP CONSTRAINT transmission_pkey,
  ADD PRIMARY KEY (areas_area_id, time),
  DROP COLUMN from_area_id,
  DROP COLUMN to_area_id
SQL
  end
end
