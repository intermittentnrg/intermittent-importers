class TransmissionPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE transmission ADD PRIMARY KEY (time, from_area_id, to_area_id)"
  end
end
