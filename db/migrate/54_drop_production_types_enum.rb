class DropProductionTypesEnum < ActiveRecord::Migration[5.1]
  def change
    change_table :generation do |t|
      t.remove :production_type
    end
    execute "DROP TYPE entsoe_production_types"
  end
end
