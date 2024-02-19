require 'composite_primary_keys'

class GenerationUnitHires < ActiveRecord::Base
  include SemanticLogger::Loggable
  belongs_to :unit
end
