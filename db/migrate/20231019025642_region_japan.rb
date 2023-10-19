class RegionJapan < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TYPE regions ADD VALUE 'japan'"
  end
end
