require 'lipseys/version'

require 'net/http'
require 'nokogiri'

require 'lipseys/base'
require 'lipseys/catalog'

module Lipseys
  class NotAuthenticated < StandardError; end
end
