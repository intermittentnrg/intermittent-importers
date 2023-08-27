class RemoveLoadConstraints < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE load
        DROP CONSTRAINT banc_max,
        DROP CONSTRAINT gb,
        DROP CONSTRAINT value_max,
        DROP CONSTRAINT value_positive
    SQL
  end
end
