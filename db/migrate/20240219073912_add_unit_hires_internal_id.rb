class AddUnitHiresInternalId < ActiveRecord::Migration[7.0]
  def change
    change_table :units do |t|
      t.string :hires_internal_id
    end
  end
end
