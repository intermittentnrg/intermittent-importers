require 'composite_primary_keys'

class Price < ActiveRecord::Base
  belongs_to :area
end
