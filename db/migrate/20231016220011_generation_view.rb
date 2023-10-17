class GenerationView < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
        CREATE VIEW generation_view AS
          SELECT apt.area_id, apt.production_type_id, g.time, g.value FROM generation g
          INNER JOIN areas_production_types apt ON(areas_production_types_id=apt.id)
        SQL
      end
      dir.down do
        execute "DROP VIEW generation_view"
      end
    end
  end
end
