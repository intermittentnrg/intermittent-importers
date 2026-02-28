class CapacitiesAptSmallint < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        execute "DROP VIEW generation_capacities"
        change_table :generation_capacities_data do |t|
          t.change :areas_production_type_id, :integer, limit: 2
          t.remove :area_id
          t.remove :production_type_id
        end
        execute <<-SQL
          CREATE VIEW generation_capacities AS
            SELECT apt.area_id, apt.production_type_id, time, value FROM generation_capacities_data g
            INNER JOIN areas_production_types apt ON(areas_production_type_id=apt.id)
        SQL
      end
    end
  end
end
