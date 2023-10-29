class DropGenerationUnitTimeIdx < ActiveRecord::Migration[7.0]
  def change
    remove_index :generation_unit, name: 'generation_unit_tmp_time_idx1'
    remove_index :generation_data, name: 'generation_tmp_time_idx'
    remove_index :load, name: 'load_tmp_time_idx'
    remove_index :prices, name: 'prices_tmp_time_idx'
    remove_index :transmission, name: 'transmission_tmp_time_idx'
  end
end
