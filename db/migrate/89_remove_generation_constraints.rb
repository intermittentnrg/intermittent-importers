class RemoveGenerationConstraints < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE generation
        DROP CONSTRAINT avrn_wind,
        DROP CONSTRAINT fpc_solar,
        DROP CONSTRAINT pjm_nuclear
    SQL
  end
end
