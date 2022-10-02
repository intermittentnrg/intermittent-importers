class RemoveTransmissionUpdatedAtTrigger < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          DROP TRIGGER trigger_set_updated_at ON transmission;
SQL
      end
    end
  end
end
