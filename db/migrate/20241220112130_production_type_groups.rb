class ProductionTypeGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :production_type_groups, id: :smallserial do |t|
      t.string :name, null: false
    end
    change_table :production_types do |t|
      t.belongs_to :production_type_group, type: :smallint, foreign_key: true
    end
  end
end
# INSERT INTO production_type_groups (name) SELECT DISTINCT name2 FROM production_types;
# UPDATE production_types pt SET production_type_group_id = (SELECT id FROM production_type_groups ptg WHERE pt.name2=ptg.name);
