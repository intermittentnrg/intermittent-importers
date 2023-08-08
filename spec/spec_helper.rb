require 'rubygems'
require 'rspec'
require 'rspec/collection_matchers'
require 'vcr'

ENV['ENV']='test'
require './lib/init'
require './lib/activerecord-connect'

ENV['ENTSOE_TOKEN'] ||= 'DUMMYTOKEN'
VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data('<TOKEN>') { ENV['ENTSOE_TOKEN'] }
  config.filter_sensitive_data('<EIA_TOKEN>') { ENV['EIA_TOKEN'] }
end

Dir["./spec/support/**/*.rb"].each { |f| require f }
