module Lipseys
  # Required options when submitting an order:
  #
  # * `:email` and `:password`
  # * `:item_number` OR `:upc`
  # * `:quantity`
  # * `:purchase_order`
  #
  # Optional order params:
  #
  # * `:notify_by_email` (boolean)
  # * `:note`
  class Order < SoapClient

    def initialize(options = {})
      requires!(options, :username, :password, :quantity, :purchase_order)
      @email = options[:username]
      @password = options[:password]
      @quantity = options[:quantity]

      @notify_by_email = (options[:notify_by_email] == true ? 'Y' : nil)
      @purchase_order = options[:purchase_order]
      @note = options[:note]

      @item_number_or_upc = options[:item_number] || options[:upc]
      raise ArgumentError.new("Either :item_number or :upc must be given") if @item_number_or_upc.nil?
    end

    def self.submit!(*args)
      new(*args).submit!
    end

    def submit!
      response = soap_client.call(:submit_order, message: build_order_data)

      raise Lipseys::NotAuthenticated if not_authenticated?(response)

      order_result = response.body[:submit_order_response][:submit_order_result]

      {
        order_number: order_result[:order_no],
        new_order: (order_result[:new_order] == 'Y'),
        success: (order_result[:success] == 'Y'),
        description: order_result[:return_desc],
        quantity_received: Integer(order_result[:qty_received]),
      }
    rescue Savon::Error => e
      { success: false, description: e.to_s }
    end

    private

    def build_order_data
      order_data = {
        EmailAddress: @email,
        Password: @password,
        LipseysItemNumberOrUPC: @item_number_or_upc,
        Qty: @quantity
      }

      order_data[:NotifyByEmail] = @notify_by_email unless @notify_by_email.nil?
      order_data[:PONumber] = @purchase_order unless @purchase_order.nil?
      order_data[:Note] = @note unless @note.nil?

      { OrderData: order_data }
    end

    def not_authenticated?(response)
      order_result = response.body[:submit_order_response][:submit_order_result]
      order_result[:success] == 'N' && order_result[:return_desc] =~ /Credentials Not Valid/i
    end

  end
end
