#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.present?
  ARGV.each do |file|
    AemoArchive::RooftopPvArchive.new File.open(file)
  end
else
  AemoArchive::RooftopPvArchive.each(&:process)
end
