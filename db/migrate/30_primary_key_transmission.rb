class PrimaryKeyTransmission < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        #deduplicate:
        execute "DELETE FROM transmission t1 WHERE EXISTS ( SELECT * FROM transmission WHERE created_at>t1.created_at AND from_area_id=t1.from_area_id AND to_area_id=t1.to_area_id AND time=t1.time)"
        execute "DROP INDEX index_transmission_on_from_area_id"
        execute "DROP INDEX index_transmission_on_to_area_id"
        execute "DROP INDEX index_transmission_on_time"
        execute "ALTER TABLE transmission ADD PRIMARY KEY (from_area_id,to_area_id,time)"
      end
    end
  end
end
