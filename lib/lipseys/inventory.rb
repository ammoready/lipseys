module Lipseys
  class Inventory < Base

    API_URL = 'https://www.lipseys.com/API/pricequantitycatalog.ashx'

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(chunk_size = 15, options = {}, &block)
      new(options).all(chunk_size, &block)
    end

    def self.quantity(chunk_size = 100, options = {}, &block)
      new(options).all(chunk_size, &block)
    end

    def self.accessories(options = {})
      new(options).accessories
    end

    def self.firearms(options = {})
      new(options).firearms
    end

    def self.nfa(options = {})
      new(options).nfa
    end

    def self.optics(options = {})
      new(options).optics
    end

    def all(size, &block)
      chunker  = Lipseys::Chunker.new(size)
      tempfile = stream_to_tempfile(API_URL, @options)

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        if chunker.is_full?
          yield(chunker.chunk)
          chunker.reset!
        else
          chunker.add(map_hash(node))
        end
      end

      # HACK-david
      # since we can't get a count of the items without reading the file
      # Let's just check to see if we have any left in the chunk
      if chunker.chunk.count > 0
        yield(chunker.chunk)
      end

      tempfile.unlink
    end

    def quantity(size, &block)
      chunker  = Lipseys::Chunker.new(size)
      tempfile = stream_to_tempfile(API_URL, @options)

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        if chunker.is_full?
          yield(chunker.chunk)
          chunker.reset!
        else
          chunker.add({
            item_identifier: content_for(node, 'ItemNo'),
            quantity: content_for(node, 'QtyOnHand')
          })
        end
      end

      if chunker.chunk.count > 0
        yield(chunker.chunk)
      end

      tempfile.unlink
    end

    def accessories
      get_items('ACCESSORY')
    end

    def firearms
      get_items('FIREARM')
    end

    def nfa
      get_items('NFA')
    end

    def optics
      get_items('OPTIC')
    end

    private

    def get_items(item_type = nil)
      @options[:itemtype] = item_type unless item_type.nil?

      xml_doc = get_response_xml(API_URL, @options)

      items = Array.new

      xml_doc.css('LipseysInventoryPricing/Item').each do |item|
        items.push(map_hash(item))
      end

      items
    end

    def map_hash(node)
      {
        item_identifier: content_for(node, 'ItemNo'),
        quantity: content_for(node, 'QtyOnHand'),
        price: content_for(node, 'Price')
      }
    end

  end
end
