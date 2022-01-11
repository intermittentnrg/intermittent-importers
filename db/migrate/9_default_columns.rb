class DefaultColumns < ActiveRecord::Migration[5.2]
  def change
    change_table :entsoe_prices do |t|
      t.change_default :created_at, from: 'CURRENT_TIMESTAMP', to: -> { 'CURRENT_TIMESTAMP' }
      t.change_default :updated_at, from: 'CURRENT_TIMESTAMP', to: -> { 'CURRENT_TIMESTAMP' }
    end
    change_table :entsoe_generation do |t|
      t.change_default :created_at, from: 'CURRENT_TIMESTAMP', to: -> { 'CURRENT_TIMESTAMP' }
      t.change_default :updated_at, from: 'CURRENT_TIMESTAMP', to: -> { 'CURRENT_TIMESTAMP' }
    end
    change_table :entsoe_load do |t|
      t.change_default :created_at, from: 'CURRENT_TIMESTAMP', to: -> { 'CURRENT_TIMESTAMP' }
      t.change_default :updated_at, from: 'CURRENT_TIMESTAMP', to: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
