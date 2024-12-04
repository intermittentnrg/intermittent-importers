class TransmissionAsView < ActiveRecord::Migration[7.1]
  def change
    rename_table :transmission, :transmission_data
    execute <<-SQL
    CREATE VIEW transmission AS
      SELECT aa.from_area_id, aa.to_area_id, t.time, t.value FROM transmission_data t
      INNER JOIN areas_areas aa ON(areas_area_id=aa.id)
    SQL
  end
end
