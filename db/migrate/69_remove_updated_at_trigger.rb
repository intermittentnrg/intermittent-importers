class RemoveUpdatedAtTrigger < ActiveRecord::Migration[6.1]
  def change
    execute "DROP TRIGGER trigger_set_updated_at ON generation"
    execute "DROP TRIGGER trigger_set_updated_at ON load"
    execute "DROP TRIGGER trigger_set_updated_at ON prices"
  end
end
