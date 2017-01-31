module Lipseys
  class User < SoapClient

    API_URL = 'https://www.lipseys.com/API/validate.asmx?WSDL'

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
    def validate
      body = { Credentials: { EmailAddress: @options[:email], Password: @options[:password] } }
      response = soap_client(API_URL).call(:validate_dealer, message: body)

      result = response.body[:validate_dealer_response][:validate_dealer_result]

      {
        success: (result[:success] == 'Y'),
        description: result[:return_desc],
      }
    rescue Savon::Error => e
      { success: false, description: e.to_s }
    end

  end
end
