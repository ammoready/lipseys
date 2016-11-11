module Lipseys
  class SoapClient < Base

    API_URL = 'http://www.lipseys.com/webservice/LipseyAPI.asmx?WSDL'

    protected

    def soap_client
      @soap_client ||= Savon.client(wsdl: API_URL, convert_request_keys_to: :none)
    end

  end
end
