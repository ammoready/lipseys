require 'simplecov'

SimpleCov.start do
  add_filter '/spec/' 
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'active_support'
require 'active_support/core_ext'
require 'webmock/rspec'

require "lipseys"

# Require all files from the /spec/support dir
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include FixtureHelper
end
