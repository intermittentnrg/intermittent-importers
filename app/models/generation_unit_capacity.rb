require 'composite_primary_keys'

class GenerationUnitCapacity < ActiveRecord::Base
  self.primary_keys = :unit_id, :time

  belongs_to :unit
end
