class DataFile < ActiveRecord::Base
  HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'

  def self.last_modified(url, source)
    self.where(path: File.basename(url), source:) \
        .pluck(:updated_at).first \
        .try(:strftime, HTTP_DATE_FORMAT)
  end
end
