class DataFile < ActiveRecord::Migration[5.1]
  def change
    rename_table :file_lists, :data_files
  end
end
