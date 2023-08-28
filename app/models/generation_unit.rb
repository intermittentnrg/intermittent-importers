require 'composite_primary_keys'

class GenerationUnit < ActiveRecord::Base
  self.table_name = 'generation_unit'
  belongs_to :unit
end
