class AemoNemNegativeGeneration < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
UPDATE generation_unit
SET value=-value
WHERE unit_id IN(
  SELECT id FROM units
  WHERE production_type_id IN(
    SELECT id FROM production_types WHERE name IN('hydro_pumped_storage','battery_charging')
  ) AND
  area_id IN(
    SELECT id FROM areas WHERE source='aemo'
  )
)
SQL
    execute <<-SQL
UPDATE generation
SET value=-value
WHERE production_type_id IN(
  SELECT id FROM production_types WHERE name IN('hydro_pumped_storage','battery_charging')
) AND
area_id IN(
  SELECT id FROM areas WHERE source='aemo'
)
SQL
  end
end
