class RenameGenerationHiresToGenerationUnitHires < ActiveRecord::Migration[7.0]
  def change
    rename_table :generation_hires_data, :generation_unit_hires
  end
end
