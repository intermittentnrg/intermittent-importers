class AddOns < ActiveRecord::Migration[7.1]
  def change
    add_enum_value('source_types', 'ons')
    add_enum_value('regions', 'brazil')
  end
end
