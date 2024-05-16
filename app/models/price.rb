class Price < ActiveRecord::Base
  acts_as_hypertable time_column: 'time'
  belongs_to :area
end
