require "httparty"
require "digest"
require "json"

module MixpanelExport
  API_ENDPOINT = "http://mixpanel.com/api/2.0"

  class RequestError < HTTParty::Error; end

  class Request
    include HTTParty
    base_uri API_ENDPOINT

    def initialize(api_secret, api_key)
      @api_secret = api_secret
      @api_key = api_key
    end

    def get(path, options={})
      response = self.class.get(path, query: build_query(Hash[normalize(options)]))

      if response.success?
        response.parsed_response || ""
      else
        raise RequestError, response.parsed_response["error"]
      end
    end

    private

    attr_reader :api_secret, :api_key

    def calculate_signature(args)
      digest = Digest::MD5.new
      digest << args.map { |k,v| "#{k}=#{v}" }.sort.join
      digest << api_secret
      digest.hexdigest
    end

    def build_query(options)
      query = options.dup || {}

      query = ({
        format:  default_format,
        expire:  default_request_expiration,
        api_key: api_key
      }).merge(query)

      query.merge!(sig: calculate_signature(query))
      query
    end

    def normalize(hash={})
      hash.map do |k,v|
        k, v =
          k, case v
          when is_a?(String)
            v.encode("utf-8")
          when is_a?(Array)
            JSON.dump(v).encode("utf-8")
          when is_a?(Hash)
            normalize(v)
          else
            v.to_s
          end
      end
    end

    def default_format
      "json"
    end

    def default_request_expiration
      Time.now.utc.to_i + 600
    end
  end
end
