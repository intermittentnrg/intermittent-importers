class AreaInternalId < ActiveRecord::Migration[5.1]
  def change
    change_table :areas do |t|
      t.rename :entsoe_id, :internal_id
    end
  end
end
