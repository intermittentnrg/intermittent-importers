class GenerationUnitHires < ActiveRecord::Base
  include SemanticLogger::Loggable
  acts_as_hypertable time_column: 'time'
  belongs_to :unit
end
