class Smallint1 < ActiveRecord::Migration[5.2]
  def change
    change_table :areas do |t|
      t.change :id, :integer, null: false, limit: 2
    end

    change_table :production_types do |t|
      t.change :id, :integer, null: false, limit: 2
    end

    change_table :units do |t|
      t.change :id, :integer, null: false, limit: 2
      t.change :area_id, :integer, null: false, limit: 2
      t.change :production_type_id, :integer, null: false, limit: 2
    end
  end
end
