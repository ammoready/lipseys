module Lipseys
  # Each method will return an array of catalog items with the following fields:
  #
  #   {
  #     item_number: content_for(item, 'ItemNo'),
  #     description_1: content_for(item, 'Desc1'),
  #     description_2: content_for(item, 'Desc2'),
  #     upc: content_for(item, 'UPC'),
  #     manufacturer_model_number: content_for(item, 'MFGModelNo'),
  #     msrp: content_for(item, 'MSRP'),
  #     model: content_for(item, 'Model'),
  #     caliber: content_for(item, 'Caliber'),
  #     manufacturer: content_for(item, 'MFG'),
  #     type: content_for(item, 'Type'),
  #     action: content_for(item, 'Action'),
  #     barrel: content_for(item, 'Barrel'),
  #     capacity: content_for(item, 'Capacity'),
  #     finish: content_for(item, 'Finish'),
  #     length: content_for(item, 'Length'),
  #     receiver: content_for(item, 'Receiver'),
  #     safety: content_for(item, 'Safety'),
  #     sights: content_for(item, 'Sights'),
  #     stock_frame_grips: content_for(item, 'StockFrameGrips'),
  #     magazine: content_for(item, 'Magazine'),
  #     weight: content_for(item, 'Weight'),
  #     image: "http://www.lipseys.net/images/#{content_for(item, 'Image')}",
  #     chamber: content_for(item, 'Chamber'),
  #     drilled_tapped: (content_for(item, 'DrilledTapped') == 'Y'),
  #     rate_of_twist: content_for(item, 'RateOfTwist'),
  #     item_type: content_for(item, 'ItemType'),
  #     feature_1: content_for(item, 'Feature1'),
  #     feature_2: content_for(item, 'Feature2'),
  #     feature_3: content_for(item, 'Feature3'),
  #     shipping_weight: content_for(item, 'ShippingWeight'),
  #     bound_book: {
  #       model: content_for(item, 'BoundBookModel'),
  #       type: content_for(item, 'BoundBookType'),
  #       manufacturer: content_for(item, 'BoundBookMFG'),
  #     },
  #     nfa: {
  #       thread_pattern: content_for(item, 'NFAThreadPattern'),
  #       attach_method: content_for(item, 'NFAAttachMethod'),
  #       baffle: content_for(item, 'NFABaffle'),
  #       can_disassemble: (content_for(item, 'NFACanDisassemble') == 'Y'),
  #       construction: content_for(item, 'NFAConstruction'),
  #       db_reduction: content_for(item, 'NFAdbReduction'),
  #       diameter: content_for(item, 'NFADiameter'),
  #       form_3_caliber: content_for(item, 'NFAForm3Caliber'),
  #     },
  #     optic: {
  #       magnification: content_for(item, 'Magnification'),
  #       maintube: content_for(item, 'Maintube'),
  #       objective: content_for(item, 'Objective'),
  #       adjustable_objective: (content_for(item, 'AdjustableObjective') == 'Y'),
  #       optic_adjustments: content_for(item, 'OpticAdjustments'),
  #       reticle: content_for(item, 'Reticle'),
  #       illuminated_reticle: (content_for(item, 'IlluminatedReticle') == 'Y'),
  #     }
  #   }
  class Catalog < Base

    API_URL = 'https://www.lipseys.com/API/catalog.ashx'


    def initialize(options = {})
      requires!(options, :email, :password)
      @email = options[:email]
      @password = options[:password]
    end


    def self.all(options = {})
      new(options).all
    end

    def all
      params = {
        email:  @email,
        pass:   @password
      }
      tempfile = stream_to_tempfile(API_URL, params)

      items = Array.new

      Lipseys::Parser.parse(tempfile, 'Item') do |node|
        items.push(map_hash(node))
      end

      items
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

      xml_doc.css('LipseysCatalog/Item').each do |item|
        items.push(map_hash(item))
      end

      items
    end

    def map_hash(node)
      {
        item_number: content_for(node, 'ItemNo'),
        description_1: content_for(node, 'Desc1'),
        description_2: content_for(node, 'Desc2'),
        upc: content_for(node, 'UPC'),
        manufacturer_model_number: content_for(node, 'MFGModelNo'),
        msrp: content_for(node, 'MSRP'),
        model: content_for(node, 'Model'),
        caliber: content_for(node, 'Caliber'),
        manufacturer: content_for(node, 'MFG'),
        type: content_for(node, 'Type'),
        action: content_for(node, 'Action'),
        barrel: content_for(node, 'Barrel'),
        capacity: content_for(node, 'Capacity'),
        finish: content_for(node, 'Finish'),
        length: content_for(node, 'Length'),
        receiver: content_for(node, 'Receiver'),
        safety: content_for(node, 'Safety'),
        sights: content_for(node, 'Sights'),
        stock_frame_grips: content_for(node, 'StockFrameGrips'),
        magazine: content_for(node, 'Magazine'),
        weight: content_for(node, 'Weight'),
        image: "http://www.lipseys.net/images/#{content_for(node, 'Image')}",
        chamber: content_for(node, 'Chamber'),
        drilled_tapped: (content_for(node, 'DrilledTapped') == 'Y'),
        rate_of_twist: content_for(node, 'RateOfTwist'),
        item_type: content_for(node, 'ItemType'),
        feature_1: content_for(node, 'Feature1'),
        feature_2: content_for(node, 'Feature2'),
        feature_3: content_for(node, 'Feature3'),
        shipping_weight: content_for(node, 'ShippingWeight'),
        bound_book: {
          model: content_for(node, 'BoundBookModel'),
          type: content_for(node, 'BoundBookType'),
          manufacturer: content_for(node, 'BoundBookMFG'),
        },
        nfa: {
          thread_pattern: content_for(node, 'NFAThreadPattern'),
          attach_method: content_for(node, 'NFAAttachMethod'),
          baffle: content_for(node, 'NFABaffle'),
          can_disassemble: (content_for(node, 'NFACanDisassemble') == 'Y'),
          construction: content_for(node, 'NFAConstruction'),
          db_reduction: content_for(node, 'NFAdbReduction'),
          diameter: content_for(node, 'NFADiameter'),
          form_3_caliber: content_for(node, 'NFAForm3Caliber'),
        },
        optic: {
          magnification: content_for(node, 'Magnification'),
          maintube: content_for(node, 'Maintube'),
          objective: content_for(node, 'Objective'),
          adjustable_objective: (content_for(node, 'AdjustableObjective') == 'Y'),
          optic_adjustments: content_for(node, 'OpticAdjustments'),
          reticle: content_for(node, 'Reticle'),
          illuminated_reticle: (content_for(node, 'IlluminatedReticle') == 'Y'),
        }
      }
    end

  end
end
