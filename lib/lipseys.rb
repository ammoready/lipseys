require 'lipseys/base'
require 'lipseys/version'

require 'lipseys/api'
require 'lipseys/catalog'
require 'lipseys/client'
require 'lipseys/error'
require 'lipseys/inventory'
require 'lipseys/items'
require 'lipseys/order'
require 'lipseys/response'
require 'lipseys/shipping'
require 'lipseys/user'

module Lipseys

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  class Configuration
    attr_accessor :proxy_address
    attr_accessor :proxy_port

    def initialize
      @proxy_address ||= nil
      @proxy_port    ||= nil
    end
  end

end
