class TransmissionInKwh < ActiveRecord::Migration[5.2]
  def change
    execute "UPDATE transmission SET value=value*1000 WHERE value IS NOT NULL"
    execute "UPDATE transmission SET capacity=capacity*1000 WHERE capacity IS NOT NULL"
  end
end
