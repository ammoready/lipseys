module Lipseys
  class Catalog < Base

    API_URL = 'https://www.lipseys.com/API/catalog.ashx'

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(chunk_size = 15, options = {}, &block)
      requires!(options, :username, :password)
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

    def all(chunk_size, &block)
      chunker   = Lipseys::Chunker.new(chunk_size)
      tempfile  = stream_to_tempfile(API_URL, @options)
      inventory = Array.new

      # Let's get the inventory and toss 'er into an array
      Lipseys::Parser.parse(stream_to_tempfile(Lipseys::Inventory::API_URL, @options), 'Item') do |node|
        inventory.push({
          item_identifier: content_for(node, 'ItemNo'),
          map_price: content_for(node, 'RetailMAP'),
          quantity: content_for(node, 'QtyOnHand'),
          price: content_for(node, 'Price')
        })
      end

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        if chunker.is_full?
          yield(chunker.chunk)

          chunker.reset!
        else
          hash = map_hash(node)
          availability = inventory.select { |i| i[:item_identifier] == hash[:item_identifier] }.first

          if availability
            hash[:price]     = availability[:price]
            hash[:quantity]  = availability[:quantity]
            hash[:map_price] = availability[:map_price]

            chunker.add(hash)
          end
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

      xml_doc.css('LipseysCatalog/Item').each do |item|
        items.push(map_hash(item))
      end

      items
    end

    def map_hash(node)
      model      = content_for(node, 'Model')
      mfg_number = content_for(node, 'MFGModelNo')
      name       = "#{model} #{mfg_number}"

      {
        name: name,
        model: model,
        upc: content_for(node, 'UPC'),
        short_description: content_for(node, 'Desc2'),
        category: content_for(node, 'Type'),
        price: nil,
        weight: content_for(node, 'Weight'),
        item_identifier: content_for(node, 'ItemNo'),
        brand: content_for(node, 'MFG'),
        mfg_number: mfg_number,
        image_url: "http://www.lipseys.net/images/#{content_for(node, 'Image')}",
        features: {
          caliber:  content_for(node, 'Caliber'),
          action:   content_for(node, 'Action'),
          barrel:   content_for(node, 'Barrel'),
          capacity: content_for(node, 'Capacity'),
          finish:   content_for(node, 'Finish'),
          length:   content_for(node, 'Length'),
          receiver: content_for(node, 'Receiver'),
          safety:   content_for(node, 'Safety'),
          sights:   content_for(node, 'Sights'),
          magazine: content_for(node, 'Magazine'),
          chamber:  content_for(node, 'Chamber')
        }
      }
    end

  end
end
