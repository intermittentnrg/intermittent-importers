class TransmissionReorderPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE transmission
  DROP CONSTRAINT transmission_pkey,
  ADD PRIMARY KEY(from_area_id,to_area_id,time)
SQL
  end
end
