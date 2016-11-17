module Lipseys
  class User < Base

    def initialize(options = {})
      requires!(options, :email, :password)
      @options = options
    end

    def authenticated?
      # As an auth check, just try to get invoices with a bogus order number.
      Lipseys::Invoice.all(@options.merge(order_number: 'abc'))
      true
    rescue Lipseys::NotAuthenticated
      false
    end

  end
end
