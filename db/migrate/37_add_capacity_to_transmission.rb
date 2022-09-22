class AddCapacityToTransmission < ActiveRecord::Migration[5.1]
  def change
    change_table :transmission do |t|
      t.change :value, :integer, null: true
      t.integer :capacity, null: true
    end
  end
end
