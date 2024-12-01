#!/usr/bin/env ruby
require './lib/init'

r = Grafanimate::TransmissionMap.new
begin
  r.scenesapi
ensure
  r.quit
end
