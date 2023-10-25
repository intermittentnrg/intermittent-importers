class FkGenerationAreasProductionTypes < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :generation_data, :areas_production_types
  end
end
