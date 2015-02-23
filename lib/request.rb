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
      response = self.class.get(path, query: build_query(options))
      raise RequestError, response.parsed_response["error"] unless response.success?
      response.parsed_response || ""
    end

    private

    attr_reader :api_secret, :api_key

    def calculate_signature(args)
      digest = Digest::MD5.new
      digest << args.map do |k,v|
        "#{k}="
          << case v
             when is_a?(String)
               v.encode("utf-8")
             when is_a?(Array)
               JSON.dump(v).encode("utf-8")
             else
               v.to_s
             end
      end.sort.join
      digest << api_secret
      digest.hexdigest
    end

    def build_query(options)
      query = options.dup || {}

      query = ({
        format: default_format,
        expire: default_request_expiration,
        api_key: api_key
      }).merge(query)

      query.merge!(sig: calculate_signature(query))
      query
    end

    def default_format
      "json"
    end

    def default_request_expiration
      Time.now.to_i + 600
    end
  end
end
