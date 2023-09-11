#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length == 2
  from = Chronic.parse(ARGV.shift).to_date
  to = Chronic.parse(ARGV.shift).to_date
  (from...to).select {|d| d.day==1}.each do |date|
    AemoWem::ScadaWem.new(date).process
  end
elsif ARGV.present?
  ARGV.each do |path|
    AemoWem::ScadaWem.new(path).process
  end
else
  Aemo::Scada.each &:process
end
