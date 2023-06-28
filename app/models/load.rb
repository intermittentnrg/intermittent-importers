require 'composite_primary_keys'

class Load < ActiveRecord::Base
  @@logger = SemanticLogger[Load]
  self.table_name = 'load'
  belongs_to :area
end
