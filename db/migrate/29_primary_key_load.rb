class PrimaryKeyLoad < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        execute "DROP INDEX index_load_on_time_and_area_id"
        execute "ALTER TABLE load ADD PRIMARY KEY (area_id,time)"
      end
    end
  end
end
