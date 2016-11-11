module Lipseys
  class SoapClient < Base

    API_URL = 'http://www.lipseys.com/webservice/LipseyAPI.asmx?WSDL'

    protected

    def soap_client
      @soap_client ||= Savon.client(wsdl: API_URL, convert_request_keys_to: :none)
    end

    def not_authenticated?(response)
      order_result = response.body[:submit_order_response][:submit_order_result]
      order_result[:success] == 'N' && order_result[:return_desc] =~ /Credentials Not Valid/i
    end

  end
end
