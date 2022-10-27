class LoadMaxBanc < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE load ADD CONSTRAINT banc_max CHECK (NOT (value>6000 AND area_id=93))
    SQL
  end
end
