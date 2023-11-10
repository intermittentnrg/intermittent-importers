class AreasProductionTypesSource < ActiveRecord::Migration[7.0]
  def change
    add_column :areas_production_types, :source, 'source_types'
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE areas_production_types SET source=(SELECT source FROM areas a WHERE area_id=a.id)
        SQL
      end
      change_column :areas_production_types, :source, 'source_types', null: false
    end
  end
end
