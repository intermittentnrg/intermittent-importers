require 'semantic_logger'
require 'composite_primary_keys'

class Transmission < ActiveRecord::Base
  @@logger = SemanticLogger[Transmission]
  self.table_name = 'transmission'
  belongs_to :from_area, class_name: 'Area'
  belongs_to :to_area, class_name: 'Area'
end
