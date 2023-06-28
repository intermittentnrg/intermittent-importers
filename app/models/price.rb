require 'composite_primary_keys'

class Price < ActiveRecord::Base
  @@logger = SemanticLogger[Price]
  belongs_to :area
end
