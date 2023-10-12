require 'composite_primary_keys'

class Load < ActiveRecord::Base
  self.table_name = 'load'
  belongs_to :area

  def inspect
    if value > 1000000
      s = "#{value/1000000.0} GW"
    elsif value > 1000
      s = "#{value/1000.0} MW"
    else
      s = "#{value} kW"
    end
    "#<Load area_id: #{area_id} time: #{time} value: #{s}>"
  end
end
