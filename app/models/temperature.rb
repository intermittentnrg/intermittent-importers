require 'composite_primary_keys'

class Temperature < ActiveRecord::Base
  belongs_to :location
end
