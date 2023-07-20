require 'composite_primary_keys'

class GenerationUnit < ActiveRecord::Base
  belongs_to :unit
end
