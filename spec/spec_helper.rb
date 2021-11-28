require 'rubygems'
require 'rspec'
require 'rspec/collection_matchers'
require 'vcr'

require './lib/entsoe'
require './lib/svk'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data('<TOKEN>') { ENV['ENTSOE_TOKEN'] }
end
