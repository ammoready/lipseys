module Lipseys
  class Inventory < Base

    def initialize(options = {})
      requires!(options, :username, :password)

      @client = Lipseys::Client.new(username: options[:username], password: options[:password])
    end

    def self.all(options = {})
      requires!(options, :username, :password)

      new(options).all
    end
    class << self; alias_method :quantity, :all; end

    def all
      @client.items.pricing_quantity_feed[:data][:items].map { |item| map_hash(item) }
    end

    private

    def map_hash(item)
      {
        item_identifier: item[:itemNumber],
        quantity: item[:quantity],
        price: item[:price],
      }
    end

  end
end
