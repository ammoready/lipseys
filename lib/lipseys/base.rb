module Lipseys
  class Base

    protected

    # Wrapper to `self.requires!` that can be used as an instance method.
    def requires!(*args)
      self.class.requires!(*args)
    end

    def self.requires!(hash, *params)
      params.each do |param|
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first)

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of: #{valid_options.join(', ')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param)
        end
      end
    end

    def content_for(xml_doc, field)
      node = xml_doc.css(field).first
      node.nil? ? nil : node.content.strip
    end

    def get_response_xml(api_url, params)
      uri = URI(api_url)
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.get_response(uri)
      xml_doc = Nokogiri::XML(response.body)

      raise Lipseys::NotAuthenticated if not_authenticated?(xml_doc)

      xml_doc
    end

    def not_authenticated?(xml_doc)
      msg = content_for(xml_doc, 'CatalogError')
      msg =~ /Login failed/i
    end

    def stream_to_tempfile(api_url, params)
      tempfile  = Tempfile.new
      uri       = URI(api_url)
      uri.query = URI.encode_www_form(params)

      Net::HTTP.get_response(uri) do |response|
        File.open(tempfile, 'w') do |file|
          response.read_body do |chunk|
            file.write(chunk.force_encoding('UTF-8'))
          end
        end
      end

      tempfile
    end

  end
end
