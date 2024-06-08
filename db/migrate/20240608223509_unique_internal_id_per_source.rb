class UniqueInternalIdPerSource < ActiveRecord::Migration[7.1]
  def change
    change_table :areas do |t|
      t.remove_index name: 'index_areas_on_internal_id'
      t.remove_index name: 'index_areas_on_code'
      t.index [:internal_id, :source], unique: true
    end
  end
end
