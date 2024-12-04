class AddNameToAreas < ActiveRecord::Migration[7.1]
  def change
    change_table :areas do |t|
      t.text :name, null: true
    end
  end
end
