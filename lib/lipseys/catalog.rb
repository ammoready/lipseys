module Lipseys
  class Catalog < Base

    CHUNK_SIZE = 500
    API_URL    = 'https://www.lipseys.com/API/catalog.ashx'
    ITEMTYPES  = %w(ACCESSORY FIREARM NFA OPTIC)

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.all(options = {}, &block)
      requires!(options, :username, :password)
      new(options).all &block
    end

    def all(&block)
      inventory_tempfile = stream_to_tempfile(Lipseys::Inventory::API_URL, @options)
      catalog_tempfile   = stream_to_tempfile(API_URL, @options)
      inventory          = Array.new

      # Let's get the inventory and toss 'er into an array
      Lipseys::Parser.parse(inventory_tempfile, 'Item') do |node|
        inventory.push({
          item_identifier: content_for(node, 'ItemNo'),
          map_price: content_for(node, 'RetailMAP'),
          quantity: content_for(node, 'QtyOnHand'),
          price: content_for(node, 'Price')
        })
      end

      Lipseys::Parser.parse(catalog_tempfile, 'Item') do |node|
        hash = map_hash(node)
        availability = inventory.select { |i| i[:item_identifier] == hash[:item_identifier] }.first

        if availability
          hash[:price]     = availability[:price]
          hash[:quantity]  = availability[:quantity]
          hash[:map_price] = availability[:map_price]
        end

        yield hash
      end

      inventory_tempfile.unlink
      catalog_tempfile.unlink
      true
    end

    private

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
