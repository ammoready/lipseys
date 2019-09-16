module Lipseys
  class SoapClient < Base

    API_URL = 'http://184.188.80.195/webservice/LipseyAPI.asmx?WSDL'

    protected

    def soap_client(api_url = API_URL)
      @soap_client ||= Savon.client(wsdl: api_url, convert_request_keys_to: :none)
    end

  end
end
