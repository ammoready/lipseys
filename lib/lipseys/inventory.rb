module Lipseys
  # Each method will return an array of inventory items with the following fields:
  #
  #   {
  #     item_number: content_for(item, 'ItemNo'),
  #     upc: content_for(item, 'UPC'),
  #     manufacturer_model_number: content_for(item, 'MFGModelNo'),
  #     quantity_on_hand: content_for(item, 'QtyOnHand'),
  #     allocation: (content_for(item, 'Allocation') == 'Y'),
  #     price: content_for(item, 'Price'),
  #     on_sale: (content_for(item, 'OnSale') == 'Y'),
  #     retail_map: content_for(item, 'RetailMAP')
  #   }
  class Inventory < Base

    API_URL = 'https://www.lipseys.com/API/pricequantitycatalog.ashx'


    def initialize(options = {})
      requires!(options, :email, :password)
      @email = options[:email]
      @password = options[:password]
    end


    def self.all(options = {})
      new(options).all
    end

    def all
      get_items
    end

    def self.all_as_chunks(size, options = {}, &block)
      new(options).all_as_chunks(size, &block)
    end

    def all_as_chunks(size, &block)
      params = {
        email:  @email,
        pass:   @password
      }
      chunker   = Lipseys::Chunker.new(size)
      tempfile  = stream_to_tempfile(API_URL, params)

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        if chunker.is_full?
          yield(chunker.chunk)

          chunker.reset
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

    def self.firearms(options = {})
      new(options).firearms
    end

    def firearms
      get_items('FIREARM')
    end

    def self.nfa(options = {})
      new(options).nfa
    end

    def nfa
      get_items('NFA')
    end

    def self.optics(options = {})
      new(options).optics
    end

    def optics
      get_items('OPTIC')
    end

    def self.accessories(options = {})
      new(options).accessories
    end

    def accessories
      get_items('ACCESSORY')
    end

    private

    def get_items(item_type = nil)
      params = { email: @email, pass: @password }
      params[:itemtype] = item_type unless item_type.nil?

      xml_doc = get_response_xml(API_URL, params)

      items = Array.new

      xml_doc.css('LipseysInventoryPricing/Item').each do |item|
        items.push(map_hash(item))
      end

      items
    end

    def map_hash(node)
      {
        item_number: content_for(node, 'ItemNo'),
        upc: content_for(node, 'UPC'),
        manufacturer_model_number: content_for(node, 'MFGModelNo'),
        quantity_on_hand: content_for(node, 'QtyOnHand'),
        allocation: (content_for(node, 'Allocation') == 'Y'),
        price: content_for(node, 'Price'),
        on_sale: (content_for(node, 'OnSale') == 'Y'),
        retail_map: content_for(node, 'RetailMAP')
      }
    end

  end
end
