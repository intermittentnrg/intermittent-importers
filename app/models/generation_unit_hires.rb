class GenerationUnitHires < ActiveRecord::Base
  include SemanticLogger::Loggable
  belongs_to :unit
end
