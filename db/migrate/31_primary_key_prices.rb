class PrimaryKeyPrices < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        #deduplicate:
        execute "DELETE FROM prices p1 WHERE EXISTS ( SELECT * FROM prices WHERE created_at>p1.created_at AND area_id=p1.area_id AND time=p1.time)"
        execute "DROP INDEX entsoe_prices_time_idx"
        execute "ALTER TABLE prices ADD PRIMARY KEY (area_id,time)"
      end
    end
  end
end
