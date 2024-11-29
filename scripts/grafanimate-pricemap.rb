#!/usr/bin/env ruby
require './lib/init'

r = Grafanimate::PriceMap.new
begin
  r.timepicker
ensure
  r.quit
end
