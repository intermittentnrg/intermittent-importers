class GenerationCapacityView < ActiveRecord::Migration[7.0]
  def change
    rename_table :generation_capacities, :generation_capacities_data
    execute <<-SQL
      CREATE VIEW generation_capacities AS
        SELECT apt.area_id, apt.production_type_id, time, value FROM generation_capacities_data g
        INNER JOIN areas_production_types apt ON(areas_production_type_id=apt.id)
    SQL
  end
end
