class RemoveAzpsNuclearConstraint < ActiveRecord::Migration[5.1]
  def change
    remove_check_constraint :generation, name: 'azps_nuclear'
  end
end
