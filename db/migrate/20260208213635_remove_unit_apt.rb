class RemoveUnitApt < ActiveRecord::Migration[7.1]
  def change
    remove_column :units, :areas_production_type_id
  end
end
