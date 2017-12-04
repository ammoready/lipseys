module Lipseys
  class Image < Base

    API_URL = 'https://www.lipseys.com/API/catalog.ashx'

    def initialize(options = {})
      requires!(options, :username, :password)

      @options = options
    end

    def self.urls(options = {})
      new(options).urls
    end

    def urls(options = {})
      tempfile  = stream_to_tempfile(API_URL, @options)
      images    = Array.new

      Lipseys::Parser.parse(tempfile, 'Item') do |item|
        image = Hash.new
        image[:item_identifier] = content_for(item, 'ItemNo')
        image[:url] = "http://www.lipseys.net/images/#{content_for(item, 'Image')}"

        images.push(image)
      end

      images
    end

  end
end
