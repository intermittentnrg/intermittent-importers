class AddCammesa < ActiveRecord::Migration[7.1]
  def change
    add_enum_value('source_types', 'cammesa')
    rename_enum_value('regions', from: 'brazil', to: 'south_america')
  end
end
