require 'webmock/rspec'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "lipseys"

# Require all files from the /spec/support dir
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.include Mocker
end
