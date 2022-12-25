$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'rspec'
require 'rspec/its'
require 'pivot_table'
require 'ostruct'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["./spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include Helpers
end
