class Location < ActiveRecord::Base
  has_many :areas
  has_many :temperatures
end
