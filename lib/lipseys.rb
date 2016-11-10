require 'lipseys/version'

require 'net/http'
require 'nokogiri'

require 'lipseys/base'
require 'lipseys/catalog'
require 'lipseys/inventory'

module Lipseys
  class NotAuthenticated < StandardError; end
end
