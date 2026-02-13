class DataFile < ActiveRecord::Base
  def self.last_modified(url, source)
    where(path: File.basename(url), source:) \
      .pluck(:updated_at).first \
      .try(:httpdate)
  end
end
