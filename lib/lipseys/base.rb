module Lipseys
  class Base

    protected

    def requires!(*args)
      self.class.requires!(*args)
    end

    def self.requires!(hash, *params)
      hash_keys = collect_hash_keys(hash)

      params.each do |param|
        if param.is_a?(Array)
          raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash_keys.include?(param.first)

          valid_options = param[1..-1]
          raise ArgumentError.new("Parameter: #{param.first} must be one of: #{valid_options.join(', ')}") unless valid_options.include?(hash[param.first])
        else
          raise ArgumentError.new("Missing required parameter: #{param}") unless hash_keys.include?(param)
        end
      end
    end

    private

    def self.collect_hash_keys(hash)
      hash.each_with_object([]) do |(k,v), keys|
        keys << k
        keys.concat(self.collect_hash_keys(v)) if v.is_a?(Hash)
      end
    end

  end
end
