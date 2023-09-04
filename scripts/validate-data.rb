#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Validate.validate_data(ARGV == ['--delete'])
