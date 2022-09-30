class TransmissionUnsigned < ActiveRecord::Migration[5.1]
  def change
    change_table :transmission do |t|
      t.change :value, :integer, null: true, unsigned: true
      t.change :capacity, :integer, null: true, unsigned: true
    end
    execute <<-SQL
      ALTER TABLE transmission
        ADD CONSTRAINT value_positive CHECK (value>=0),
        ADD CONSTRAINT capacity_positive CHECK (capacity>=0)
    SQL
  end
end
