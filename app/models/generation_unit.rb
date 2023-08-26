require 'composite_primary_keys'

class GenerationUnit < ActiveRecord::Base
  self.table_name = 'generation_unit'
  #self.primary_keys = :time, :unit_id
  belongs_to :unit
end
