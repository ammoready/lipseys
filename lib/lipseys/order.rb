require 'lipseys/api'

module Lipseys
  class Order < Base

    include Lipseys::API

    SUBMIT_TO_STORE_ATTRS = {
      permitted: %i( po_number disable_email items item_number quantity note ).freeze,
      required:  %i( items item_number quantity ).freeze
    }

    SUBMIT_TO_DROP_SHIP_ATTRS = {
      permitted: %i(
        warehouse po_number billing_name billing_address_line_1 billing_address_line_2 billing_address_city
        billing_address_state billing_address_zip shipping_name shipping_address_line_1 shipping_address_line_2
        shipping_address_city shipping_address_state shipping_address_zip message_for_sales_exec disable_email
        items item_number quantity note overnight
      ).freeze,
      required: %i(
        po_number billing_name billing_address_line_1  billing_address_city billing_address_state billing_address_zip
        shipping_name shipping_address_line_1 shipping_address_city shipping_address_state shipping_address_zip
        items item_number quantity
      ).freeze
    }

    ENDPOINTS = {
      submit_to_store:     "order/apiorder".freeze,
      submit_to_drop_ship: "order/dropship".freeze,
    }

    def initialize(client)
      @client = client
    end

    def submit_to_store(order_data)
      requires!(order_data, *SUBMIT_TO_STORE_ATTRS[:required])

      endpoint = ENDPOINTS[:submit_to_store]
      headers = [
        *auth_header(@client.access_token),
        *content_type_header('application/json'),
      ].to_h

      order_data = standardize_body_data(order_data, SUBMIT_TO_STORE_ATTRS[:permitted])

      post_request(endpoint, order_data, headers)
    end

    def submit_to_drop_ship(order_data)
      # NOTE: Will build this out as time permits.
      false
    end

  end
end
