class GenerationProductionTypeId < ActiveRecord::Migration[5.2]
  def change
    change_table :generation do |t|
      t.integer :production_type_id, limit: 2 #, null: false
    end
  end
end
