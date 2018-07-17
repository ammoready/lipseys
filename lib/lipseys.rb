require 'lipseys/version'

require 'net/http'
require 'nokogiri'
require 'savon'

require 'lipseys/base'
require 'lipseys/soap_client'

require 'lipseys/catalog'
require 'lipseys/inventory'
require 'lipseys/invoice'
require 'lipseys/order'
require 'lipseys/user'
require 'lipseys/image'
require 'lipseys/parser'

module Lipseys
  class NotAuthenticated < StandardError; end
end
