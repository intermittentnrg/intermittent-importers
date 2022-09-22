class ProductionTypeIdNotNull < ActiveRecord::Migration[5.2]
  def change
    execute "UPDATE generation g SET production_type_id = pt.id FROM production_types pt WHERE g.production_type::text = pt.name AND production_type_id IS NULL"
    change_table :generation do |t|
      t.change :production_type_id, :integer, limit: 2, null: false
    end
  end
end
