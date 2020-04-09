require 'lipseys/api'
require 'lipseys/items'
require 'lipseys/order'
require 'lipseys/shipping'

module Lipseys
  class Client < Base

    include Lipseys::API

    attr_accessor :access_token

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options

      authenticate!
    end

    def items
      @items ||= Lipseys::Items.new(self)
    end

    def order
      @order ||= Lipseys::Order.new(self)
    end

    def shipping
      @shipping ||= Lipseys::Shipping.new(self)
    end

    private

    def authenticate!
      response = post_request(
        'authentication/login',
        { email: @options[:username], password: @options[:password] },
        content_type_header('application/json')
      )

      if response[:token].present?
        self.access_token = response[:token]
      else
        raise Lipseys::Error::NotAuthorized.new(response.body)
      end
    end

  end
end
