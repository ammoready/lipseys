module Lipseys
  class User < Base

    def initialize(options = {})
      requires!(options, :username, :password)

      @client = Lipseys::Client.new(username: options[:username], password: options[:password])
    end

    def authenticated?
      @client.access_token.present?
    end

  end
end
