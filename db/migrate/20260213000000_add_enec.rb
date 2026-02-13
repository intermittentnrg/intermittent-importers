class AddEnec < ActiveRecord::Migration[7.1]
  def change
    add_enum_value 'source_types', 'enec'
    add_enum_value 'regions', 'uae'
  end
end
