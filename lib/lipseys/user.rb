module Lipseys
  class User < SoapClient

    API_URL = 'http://184.188.80.195/API/validate.asmx?WSDL'

    def initialize(options = {})
      requires!(options, :username, :password)
      @options = options
    end

    def authenticated?
      validate[:success]
    end

    def validate
      body = { Credentials: { EmailAddress: @options[:username], Password: @options[:password] } }
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
