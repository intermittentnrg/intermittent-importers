#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.present?
  ARGV.each do |file|
    Aemo::RooftopPvArchive.new File.open(file)
  end
else
  Aemo::RooftopPvArchive.each(&:process)
end
