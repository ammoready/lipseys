module Lipseys
  # In addition to the `:email` and `:password` options, finding invoices requires
  # either an `:order_number` **OR** a `:purchase_order`.
  #
  # The response structure will look like this:
  #
  #   {
  #     invoices_found: 1,
  #     description: "1 Invoice(s) found.",
  #     invoices: {
  #       invoice_detail: {
  #         invoice_no: "...",
  #         ship_to_location: "...",
  #         tracking_no: "...",
  #         line_items: {
  #           item_detail: {
  #             item_no: "...",
  #             upc: "...",
  #             qty: "...",
  #             serialized_item: "...",
  #             serial_numbers: {
  #               string: "..."
  #             }
  #           }
  #         }
  #       }
  #     }
  #   }
  class Invoice < SoapClient

    def initialize(options = {})
      requires!(options, :email, :password)
      @email = options[:email]
      @password = options[:password]

      @order_number = options[:order_number]
      @purchase_order = options[:purchase_order]
      raise ArgumentError.new("Either :order_number or :purchase_order is required") if @order_number.nil? && @purchase_order.nil?
    end


    def self.all(*args)
      new(*args).all
    end

    def all
      response = soap_client.call(:get_invoices, message: build_inquiry_data)

      raise Lipseys::NotAuthenticated if not_authenticated?(response)

      invoice_result = response.body[:get_invoices_response][:get_invoices_result]

      {
        invoices_found: Integer(invoice_result[:invoices_found]),
        description: invoice_result[:return_desc],

        invoices: invoice_result[:invoices]
      }
    rescue Savon::Error => e
      { success: false, description: e.to_s }
    end

    private

    def build_inquiry_data
      inquiry_data = {
        EmailAddress: @email,
        Password: @password
      }

      inquiry_data[:OrderNo] = @order_number unless @order_number.nil?
      inquiry_data[:PONumber] = @purchase_order unless @purchase_order.nil?

      { InquiryData: inquiry_data }
    end

    def not_authenticated?(response)
      invoice_result = response.body[:get_invoices_response][:get_invoices_result]
      invoice_result[:return_desc] =~ /Credentials Not Valid/i
    end

  end
end
