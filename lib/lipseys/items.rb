require 'lipseys/api'

module Lipseys
  class Items < Base

    include Lipseys::API

    ENDPOINTS = {
      catalog_feed:          "items/catalogfeed".freeze,
      pricing_quantity_feed: "items/pricingquantityfeed".freeze,
      validate_item:         "items/validateitem".freeze,
      catalog_feed_item:     "items/catalogfeed/item".freeze,
    }

    def initialize(client)
      @client = client
    end

    def catalog_feed
      endpoint = ENDPOINTS[:catalog_feed]

      get_request(endpoint, auth_header(@client.access_token))
    end

    def pricing_quantity_feed
      endpoint = ENDPOINTS[:pricing_quantity_feed]

      get_request(endpoint, auth_header(@client.access_token))
    end

    # `identifier` can be Item #, Mfg Model #, or UPC
    def validate_item(identifier)
      endpoint = ENDPOINTS[:validate_item]
      headers  = [
        *auth_header(@client.access_token),
        *content_type_header('application/json'),
      ].to_h

      post_request(endpoint, "'#{identifier}'", headers)
    end

    # `identifier` can be Item #, Mfg Model #, or UPC
    def catalog_feed_item(identifier)
      endpoint = ENDPOINTS[:catalog_feed_item]
      headers  = [
        *auth_header(@client.access_token),
        *content_type_header('application/json'),
      ].to_h

      post_request(endpoint, "'#{identifier}'", headers)
    end

  end
end
