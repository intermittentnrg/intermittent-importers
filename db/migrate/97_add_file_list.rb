class AddFileList < ActiveRecord::Migration[5.1]
  def change
    create_table :file_lists do |t|
      t.string :path, unique: true
      t.column :source, 'source_types', null: false
      t.timestamps
      t.index [:source, :path], unique: true
    end
  end
end
