class AddRegionToArea < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        execute "CREATE TYPE regions AS ENUM('europe','north_america','canary_islands')"
        change_table :areas do |t|
          t.column :region, 'regions'
        end
      end
    end
  end
end
