class CreateProductionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :production_types, id: :smallserial do |t|
      t.string :name, null: false, index: true
      t.string :name2, null: false, index: true
      t.boolean :enabled, null: false, default: true
    end
    reversible do |dir|
      dir.up do
        execute "INSERT INTO production_types (name,name2) SELECT UNNEST(ENUM_RANGE(NULL::entsoe_production_types)), ''"
      end
    end

    #change_table :generation do |t|
    #  t.integer :production_type_id, null: false
    #end
  end
end
