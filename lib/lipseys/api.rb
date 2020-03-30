require 'net/http'

module Lipseys
  module API

    ROOT_API_URL = 'https://api.lipseys.com/api/integration'.freeze
    USER_AGENT = "LipseysRubyGem/#{Lipseys::VERSION}".freeze

    FILE_UPLOAD_ATTRS = {
      permitted: %i( file_name file_type file_contents ).freeze,
      reqired:   %i( file_type file_contents ).freeze,
    }

    def get_request(endpoint, headers = {})
      request = Net::HTTP::Get.new(request_url(endpoint))

      submit_request(request, {}, headers)
    end

    def post_request(endpoint, data = {}, headers = {})
      request = Net::HTTP::Post.new(request_url(endpoint))

      submit_request(request, data, headers)
    end

    def post_file_request(endpoint, file_data, headers = {})
      request = Net::HTTP::Post.new(request_url(endpoint))

      submit_file_request(request, file_data, headers)
    end

    private

    def submit_request(request, data, headers)
      set_request_headers(request, headers)

      request.body = data.is_a?(Hash) ? data.to_json : data

      process_request(request)
    end

    def submit_file_request(request, file_data, headers)
      boundary = ::SecureRandom.hex(15)

      headers.merge!(content_type_header("multipart/form-data; boundary=#{boundary}"))

      build_multipart_request_body(request, file_data, boundary)
      set_request_headers(request, headers)
      process_request(request)
    end

    def process_request(request)
      uri = URI(request.path)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      Lipseys::Response.new(response)
    end

    def build_multipart_request_body(request, file_data, boundary)
      file_type     = file_data[:file_type]
      file_contents = file_data[:file_contents]
      file_name     = file_data[:file_name] || "ffl-document.#{file_type}"
      content_type  = "application/#{file_data[:file_type]}"

      body = []
      body << "--#{boundary}\r\n"
      body << "Content-Disposition: form-data; name=\"file\"; filename=\"#{file_name}\"\r\n"
      body << "Content-Type: #{content_type}\r\n"
      body << "\r\n"
      body << "#{file_contents}\r\n"
      body << "--#{boundary}--\r\n"

      request.body = body.join
    end

    def set_request_headers(request, headers)
      request['User-Agent'] = USER_AGENT

      headers.each { |header, value| request[header] = value }
    end

    def auth_header(token)
      { 'Token' => token }
    end

    def content_type_header(type)
      { 'Content-Type' => type }
    end

    def request_url(endpoint)
      [ROOT_API_URL, endpoint].join('/')
    end

    def standardize_body_data(submitted_data, permitted_data_attrs)
      _submitted_data = submitted_data.deep_transform_keys(&:to_sym)
      permitted_data = _submitted_data.select! do |k, v|
        if v.is_a?(Hash)
          _submitted_data[k] = _submitted_data[k].select! { |k, v| permitted_data_attrs.include?(k) }
        else
          permitted_data_attrs.include?(k)
        end
      end || _submitted_data

      permitted_data.deep_transform_keys { |k| k.to_s.camelize(:lower) }
    end

  end
end
