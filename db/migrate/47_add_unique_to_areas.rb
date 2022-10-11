class AddUniqueToAreas < ActiveRecord::Migration[5.1]
  def change
    add_index :areas, [:code, :source], unique: true
    execute <<-SQL
      ALTER TABLE areas ADD CONSTRAINT code_no_spaces CHECK (code !~ ' ')
    SQL
  end
end
