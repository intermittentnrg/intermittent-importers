class UnitHiresInternalIdUniqueIdx < ActiveRecord::Migration[7.0]
  def change
    add_index :units, :hires_internal_id, unique: true
  end
end
