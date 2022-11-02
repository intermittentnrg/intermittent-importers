class AddRegionAustralia < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
ALTER TYPE regions ADD VALUE 'australia'
SQL
      end
    end
  end
end
