class GenerationAsView < ActiveRecord::Migration[7.0]
  def change
    rename_table :generation, :generation_data
    execute <<-SQL
    CREATE VIEW generation AS
      SELECT apt.area_id, apt.production_type_id, g.time, g.value FROM generation_data g
      INNER JOIN areas_production_types apt ON(areas_production_types_id=apt.id)
    SQL
    execute "DROP VIEW generation_view"
  end
end
