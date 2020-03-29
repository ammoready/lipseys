require 'lipseys/api'

module Lipseys
  class Client < Base

    include Lipseys::API

    attr_accessor :access_token

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options

      authenticate!
    end

    private

    def authenticate!
      response = post_request(
        'authentication/login',
        { email: @options[:username], password: @options[:password] },
        content_type_header('application/json')
      )

      self.access_token = response[:token]
    end

  end
end