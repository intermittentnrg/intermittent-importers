class Eirgrid < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
ALTER TYPE source_types ADD VALUE 'eirgrid'
SQL
      end
      dir.down do
        execute <<-SQL
ALTER TYPE source_types DROP VALUE 'eirgrid'
SQL
      end
    end
  end
end
