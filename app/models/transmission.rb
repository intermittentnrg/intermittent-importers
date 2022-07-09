require 'semantic_logger'

class Transmission < ActiveRecord::Base
  @@logger = SemanticLogger[Transmission]
  self.table_name = 'transmission'
  belongs_to :from_area, class_name: 'Area'
  belongs_to :to_area, class_name: 'Area'
end
