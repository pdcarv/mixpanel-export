require "httparty"
require "digest"

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
      args_concat = args.map { |k,v| "#{k}=#{v}" }.sort.join

      Digest::MD5.hexdigest(args_concat + api_secret)
    end

    def build_query(options)
      query = options.dup || {}
      query.merge!(format: "json", api_key: api_key)
      query.merge!(expire: Time.now.to_i + 10)
      query.merge!(sig: calculate_signature(query))
      query
    end
  end
end
