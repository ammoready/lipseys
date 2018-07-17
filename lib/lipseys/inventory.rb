module Lipseys
  class Inventory < Base

    API_URL = 'https://www.lipseys.com/API/pricequantitycatalog.ashx'

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(options = {}, &block)
      new(options).all &block
    end

    def self.quantity(options = {}, &block)
      new(options).all &block
    end

    def self.get_quantity_file(options = {})
      new(options).get_quantity_file
    end

    def all(&block)
      tempfile = stream_to_tempfile(API_URL, @options)

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        yield map_hash(node)
      end

      tempfile.unlink
    end

    def get_quantity_file
      quantity_tempfile = stream_to_tempfile(API_URL, @options)
      tempfile          = Tempfile.new

      Lipseys::Parser.parse(quantity_tempfile, 'Item') do |node|
        tempfile.puts("#{content_for(node, 'ItemNo')},#{content_for(node, 'QtyOnHand')}")
      end

      quantity_tempfile.unlink
      tempfile.close

      tempfile.path
    end

    private

    def map_hash(node)
      {
        item_identifier: content_for(node, 'ItemNo'),
        quantity: content_for(node, 'QtyOnHand'),
        price: content_for(node, 'Price')
      }
    end

  end
end
