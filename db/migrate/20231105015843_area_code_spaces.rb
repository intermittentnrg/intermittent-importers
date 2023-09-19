class AreaCodeSpaces < ActiveRecord::Migration[7.0]
  def change
    remove_check_constraint :areas, name: 'code_no_spaces'
  end
end
