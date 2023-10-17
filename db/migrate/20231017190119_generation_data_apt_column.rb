class GenerationDataAptColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :generation_data, :areas_production_types_id, :areas_production_type_id
    execute <<-SQL
    CREATE OR REPLACE VIEW generation AS
      SELECT apt.area_id, apt.production_type_id, g.time, g.value FROM generation_data g
      INNER JOIN areas_production_types apt ON(areas_production_type_id=apt.id)
    SQL
  end
end
