class AreaType < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
CREATE TYPE area_types AS ENUM('country','zone','region','balancing_authority')
SQL
      end
      dir.down do
        execute "DROP TYPE area_types"
      end
    end
    change_table :areas do |t|
      t.column :type, 'area_types', null: true
    end
  end
end
