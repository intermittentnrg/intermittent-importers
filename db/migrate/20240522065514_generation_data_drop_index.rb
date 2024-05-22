class GenerationDataDropIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :generation_data, name: 'index_generation_data_on_areas_production_type_id'
  end
end
