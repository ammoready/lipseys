module Lipseys
  class Inventory < Base

    API_URL = 'http://184.188.80.195/API/pricequantitycatalog.ashx'

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(options = {})
      new(options).all
    end

    def self.quantity(options = {})
      new(options).all
    end

    def self.get_quantity_file(options = {})
      new(options).get_quantity_file
    end

    def all
      items    = []
      tempfile = stream_to_tempfile(API_URL, @options)

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        _map_hash = map_hash(node)

        items << _map_hash unless _map_hash.nil?
      end

      tempfile.unlink

      items
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
