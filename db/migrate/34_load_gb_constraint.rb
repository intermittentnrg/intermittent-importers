class LoadGbConstraint < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      ALTER TABLE load ADD CONSTRAINT gb CHECK (NOT (area_id=37 AND value<10000))
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE load DROP CONSTRAINT gb
    SQL
  end
end

