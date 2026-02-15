#!/usr/bin/env ruby

require_relative "../config/application"
Rails.application.require_environment!

r = Grafanimate::PriceMap.new
begin
  r.scenesapi
ensure
  r.quit
end
