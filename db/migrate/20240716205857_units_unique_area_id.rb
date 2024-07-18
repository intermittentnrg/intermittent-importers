class UnitsUniqueAreaId < ActiveRecord::Migration[7.1]
  def change
    change_table :units do |t|
      t.remove_index name: :index_units_on_internal_id_and_production_type_id
      t.index [:area_id, :production_type_id, :internal_id]
    end
  end
end
