class LoadUnsigned < ActiveRecord::Migration[5.1]
  def change
    change_table :load do |t|
      t.change :value, :integer, null: false, unsigned: true
    end
    execute <<-SQL
      ALTER TABLE load ADD CONSTRAINT value_positive CHECK (value>=0)
    SQL
  end
end
