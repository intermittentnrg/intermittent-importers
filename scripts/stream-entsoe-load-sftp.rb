#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger[$0]

EntsoeSFTP::Load.each &:process
