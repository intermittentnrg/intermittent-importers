class RemoveGenerationHiresUnitIdIdx < ActiveRecord::Migration[7.0]
  def change
    remove_index :generation_hires_data, name: :index_generation_hires_data_on_unit_id
  end
end
