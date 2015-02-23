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
      args_sorted = args.sort_by { |k,v| k.to_s }
      args_concat = args_sorted.map { |k,v| "#{k}=#{v}" }.join

      Digest::MD5.hexdigest(args_concat + api_secret)
    end

    def build_query(options)
      query = options.dup || {}
      query.merge!(format: :json)
      query.merge!(expire: (Time.now.utc + 10).to_i)
      query.merge!(api_key: api_key)
      query.merge!(sig: calculate_signature(query))
      query
    end
  end
end
