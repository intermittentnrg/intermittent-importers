require './app/models/area'

class FrNuclear < ActiveRecord::Migration[5.1]
  def up
    area_id = Area.where(code: 'FR', source: 'entsoe').pluck(:id).first
    return unless area_id
    execute "DELETE FROM generation WHERE area_id=#{area_id} AND production_type='nuclear' AND value > 80000"
    execute <<-SQL
      ALTER TABLE generation ADD CONSTRAINT fr_nuclear CHECK (NOT (area_id=#{area_id} AND production_type='nuclear' AND value > 80000))
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE generation DROP CONSTRAINT fr_nuclear
    SQL
  end
end
