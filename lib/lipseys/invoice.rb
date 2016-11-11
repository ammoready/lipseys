module Lipseys
  class Invoice < SoapClient

    def initialize(options = {})
      requires!(options, :email, :password)
      @email = options[:email]
      @password = options[:password]

      @order_number = options[:order_number]
      @po_number = options[:po_number]
      raise ArgumentError.new("Either :order_number or :po_number is required") if @order_number.nil? && @po_number.nil?
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

        # TODO: Parse the invoice details once an invoice is created on Lipsey's end.
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
      inquiry_data[:PONumber] = @po_number unless @po_number.nil?

      { InquiryData: inquiry_data }
    end

    def not_authenticated?(response)
      invoice_result = response.body[:get_invoices_response][:get_invoices_result]
      invoice_result[:return_desc] =~ /Credentials Not Valid/i
    end

  end
end
