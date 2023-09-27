#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-elexon-unit.rb']

if ARGV.length < 3
  $stderr.puts "#{$0} <from> <to> <unit>"
  exit 1
end
start_new = Chronic.parse(ARGV.shift).to_date.freeze
stop_new = Chronic.parse(ARGV.shift).to_date.freeze


ARGV.each do |unit|
  start = start_new.dup
  stop = stop_new.dup
  SemanticLogger.tagged(unit: unit) do
    loop do
      try = stop - (stop-start)/2
      logger.info "try #{try}"
      begin
        Elexon::Unit.new(try.to_time, unit).process
        logger.info "yes #{try} #{start} #{stop}"
        stop = try
      rescue ENTSOE::EmptyError
        logger.info "nope #{try} #{start} #{stop}"
        start = try
      ensure
        if (stop-start).to_i == 1
          logger.info "SUCCESS #{try}"
          puts "scripts/stream-elexon-unit.rb #{try} yesterday #{unit}"
          break
        end
      end
    end
  end
end
