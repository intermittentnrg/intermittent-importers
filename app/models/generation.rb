require 'composite_primary_keys'

class Generation < ActiveRecord::Base
  @@logger = SemanticLogger[Generation]
  self.table_name = 'generation'
  belongs_to :area
end
