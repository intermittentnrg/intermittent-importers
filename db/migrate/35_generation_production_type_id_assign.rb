class GenerationProductionTypeIdAssign < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute "set jit = off"
        execute "UPDATE generation g SET production_type_id = pt.id FROM production_types pt WHERE g.production_type::text = pt.name"
      end
    end
    #change_table :generation do |t|
    #  t.integer :production_type_id, limit: 2, null: false
    #  t.remove :production_type
    #end
  end
end
