#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

countries = ARGV.present? ? ARGV : Area.where(source: Opennem::Year.source_id).pluck(:code)
countries.each do |country|
  SemanticLogger.tagged(country: country) do
    e = Opennem::Latest.new country
    e.process
  end
end
