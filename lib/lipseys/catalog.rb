module Lipseys
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
      get_items
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

      items = []

      xml_doc.css('LipseysCatalog/Item').each do |item|
        items << {
          item_number: content_for(item, 'ItemNo'),
          description_1: content_for(item, 'Desc1'),
          description_2: content_for(item, 'Desc2'),
          upc: content_for(item, 'UPC'),
          manufacturer_model_number: content_for(item, 'MFGModelNo'),
          msrp: content_for(item, 'MSRP'),
          model: content_for(item, 'Model'),
          caliber: content_for(item, 'Caliber'),
          manufacturer: content_for(item, 'MFG'),
          type: content_for(item, 'Type'),
          action: content_for(item, 'Action'),
          barrel: content_for(item, 'Barrel'),
          capacity: content_for(item, 'Capacity'),
          finish: content_for(item, 'Finish'),
          length: content_for(item, 'Length'),
          receiver: content_for(item, 'Receiver'),
          safety: content_for(item, 'Safety'),
          sights: content_for(item, 'Sights'),
          stock_frame_grips: content_for(item, 'StockFrameGrips'),
          magazine: content_for(item, 'Magazine'),
          weight: content_for(item, 'Weight'),
          image: "http://www.lipseys.net/images/#{content_for(item, 'Image')}",
          chamber: content_for(item, 'Chamber'),
          drilled_tapped: (content_for(item, 'DrilledTapped') == 'Y'),
          rate_of_twist: content_for(item, 'RateOfTwist'),
          item_type: content_for(item, 'ItemType'),
          feature_1: content_for(item, 'Feature1'),
          feature_2: content_for(item, 'Feature2'),
          feature_3: content_for(item, 'Feature3'),
          shipping_weight: content_for(item, 'ShippingWeight'),
          bound_book: {
            model: content_for(item, 'BoundBookModel'),
            type: content_for(item, 'BoundBookType'),
            manufacturer: content_for(item, 'BoundBookMFG'),
          },
          nfa: {
            thread_pattern: content_for(item, 'NFAThreadPattern'),
            attach_method: content_for(item, 'NFAAttachMethod'),
            baffle: content_for(item, 'NFABaffle'),
            can_disassemble: (content_for(item, 'NFACanDisassemble') == 'Y'),
            construction: content_for(item, 'NFAConstruction'),
            db_reduction: content_for(item, 'NFAdbReduction'),
            diameter: content_for(item, 'NFADiameter'),
            form_3_caliber: content_for(item, 'NFAForm3Caliber'),
          },
          optic: {
            magnification: content_for(item, 'Magnification'),
            maintube: content_for(item, 'Maintube'),
            objective: content_for(item, 'Objective'),
            adjustable_objective: (content_for(item, 'AdjustableObjective') == 'Y'),
            optic_adjustments: content_for(item, 'OpticAdjustments'),
            reticle: content_for(item, 'Reticle'),
            illuminated_reticle: (content_for(item, 'IlluminatedReticle') == 'Y'),
          }
        }
      end

      items
    end

  end
end
