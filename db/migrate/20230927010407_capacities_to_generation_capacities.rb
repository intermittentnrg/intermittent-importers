class CapacitiesToGenerationCapacities < ActiveRecord::Migration[7.0]
  def change
    rename_table :capacities, :generation_capacities
  end
end
