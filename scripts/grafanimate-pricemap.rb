#!/usr/bin/env ruby
require './lib/init'

r = Grafanimate::PriceMap.new
begin
  r.scenesapi
ensure
  r.quit
end
