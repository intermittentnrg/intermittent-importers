class GenerationUnitInKwh < ActiveRecord::Migration[5.2]
  def change
    execute "DELETE FROM generation_units WHERE value > 2147483"
    execute "UPDATE generation_units SET value=value*1000 FROM units u, areas a WHERE unit_id=u.id AND u.area_id=a.id AND a.source<>'elexon'"
  end
end
