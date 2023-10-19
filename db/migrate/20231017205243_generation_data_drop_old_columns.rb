class GenerationDataDropOldColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :generation_data do |t|
      t.remove :area_id
      t.remove :production_type_id
    end
  end
end
