class AreasArea < ActiveRecord::Base
  belongs_to :from_area, class_name: 'Area'
  belongs_to :to_area, class_name: 'Area'
  has_many :transmission
end
