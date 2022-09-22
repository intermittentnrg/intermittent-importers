class TransmissionDecimalValue < ActiveRecord::Migration[5.1]
  def change
    change_table :transmission do |t|
      t.change :value, :decimal, null: true
    end
  end
end
