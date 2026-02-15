#!/usr/bin/env ruby
require_relative "../config/application"
Rails.application.require_environment!

Grafanimate::TransmissionMap.render
