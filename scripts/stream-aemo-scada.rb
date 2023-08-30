#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.present?
  ARGV.each do |file|
    Aemo::Scada.new File.open(file), file
  end
else
  Aemo::Scada.each &:process
end
