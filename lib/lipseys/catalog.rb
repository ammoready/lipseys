module Lipseys
  class Catalog < Base

    def initialize(options = {})
      requires!(options, :username, :password)

      @client = Lipseys::Client.new(username: options[:username], password: options[:password])
    end

    def self.all(options = {})
      requires!(options, :username, :password)

      new(options).all
    end

    def all
      @client.items.catalog_feed[:data].map { |item| map_hash(item) }
    end

    private

    def map_hash(item)
      {
        name: [item[:model].try(:strip), item[:manufacturerModelNo].try(:strip)].compact.join(' '),
        model: item[:model],
        upc: item[:upc],
        long_description: item[:description1],
        short_description: item[:description2],
        category: item[:type],
        price: item[:price],
        map_price: item[:retailMap],
        msrp: item[:msrp],
        quantity: item[:quantity],
        weight: item[:weight],
        item_identifier: item[:itemNo],
        brand: item[:manufacturer],
        mfg_number: item[:manufacturerModelNo],
        image_name: item[:imageName],
        features: {
          caliber: item[:caliberGauge],
          action: item[:action],
          barrel: item[:barrelLength],
          capacity: item[:capacity],
          finish: item[:finish],
          length: item[:overallLength],
          receiver: item[:receiver],
          safety: item[:safety],
          sights: item[:sights],
          stock_frame_grips: item[:stockFrameGrips],
          magazine: item[:magazine],
          chamber: item[:chamber],
          rate_of_twist: item[:rateOfTwist],
          additional_feature_1: item[:additionalFeature1],
          additional_feature_2: item[:additionalFeature2],
          additional_feature_3: item[:additionalFeature3],
          nfa_thread_pattern: item[:nfaThreadPattern],
          nfa_attachment_method: item[:nfaAttachmentMethod],
          nfa_baffle_type: item[:nfaBaffleType],
          nfa_db_reduction: item[:nfaDbReduction],
          nfa_form_3_caliber: item[:nfaForm3Caliber],
          optic_magnification: item[:opticMagnification],
        },
      }
    end

  end
end
