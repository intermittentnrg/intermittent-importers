class GenerationViewSourceArea < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
    CREATE OR REPLACE VIEW generation AS
      SELECT area_id, production_type_id, time, value, areas_production_type_id, source_area_id
      FROM generation_data g
      INNER JOIN areas_production_types apt ON(areas_production_type_id=apt.id)
    SQL
  end
end
