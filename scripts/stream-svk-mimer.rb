#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/svk'

require './lib/activerecord-connect'
require './app/models/svk_mimer_generation'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : Svk::COUNTRIES.keys).each do |country|
  Svk::PRODUCTION_TYPES.keys.each do |production|
    puts "#{country}/#{production}"
    e = Svk::Generation.new(country: country, production: production, from: from, to: to)
    values = e.points
    puts values
    #require 'pry' ; binding.pry
    SvkMimerGeneration.upsert_all values
  rescue
    puts $!
    puts $!.backtrace
  end
end
