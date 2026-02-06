SimpleCov.start do
  # Use different formatters for CI vs local development
  if ENV['CI']
    require 'simplecov-cobertura'
    formatter SimpleCov::Formatter::CoberturaFormatter
  else
    formatter SimpleCov::Formatter::HTMLFormatter
  end

  # Enable branch coverage tracking
  enable_coverage :branch

  # Group files into logical components
  add_group 'Libraries', 'lib'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  
  # Add filters for files you don't want to track
  add_filter 'vendor'
  add_filter 'spec'
  add_filter 'test'
  add_filter '/config/'
  
  # Minimum coverage percentage (optional)
  # minimum_coverage 90
  
  # Track coverage by line and branch
  track_files '{app,lib}/**/*.{rb,rake}'
end