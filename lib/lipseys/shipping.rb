require 'lipseys/api'

module Lipseys
  class Shipping < Base

    include Lipseys::API

    ENDPOINTS = {
      fetch: "shipping/oneday".freeze,
    }

    def initialize(client)
      @client = client
    end

    def fetch(since_date = nil)
      endpoint = ENDPOINTS[:fetch]
      since_date = (since_date || Time.now.prev_day).strftime('%m/%d/%Y')
      headers  = [
        *auth_header(@client.access_token),
        *content_type_header('application/json'),
      ].to_h

      post_request(endpoint, "\"#{since_date}\"", headers)
    end

  end
end
