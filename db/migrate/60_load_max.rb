class LoadMax < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE load ADD CONSTRAINT value_max CHECK (value<800000)
    SQL
  end
end
