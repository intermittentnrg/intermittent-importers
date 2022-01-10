class AddEntsoeGenerationIndices < ActiveRecord::Migration[5.1]
  def change
    change_table :entsoe_generation do |t|
      t.index :production_type
      t.index :country
    end
  end
end
