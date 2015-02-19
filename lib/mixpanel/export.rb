require "mixpanel/export/version"
require "mixpanel/export/events"
require "httparty"
require "digest"

module Mixpanel
  API_ENDPOINT = "http://mixpanel.com/api/2.0"

  class Request
    include HTTParty
    base_uri API_ENDPOINT

    def initialize(api_secret, api_key)
      @api_secret = api_secret
      @api_key = api_key
    end

    def get(path, options={})
      query = options.fetch(:format, "json")
      query = options.merge(sig: calculate_signature(options), api_key: api_key)

      response = self.class.get(path, query: query)
      raise response.response unless response.success?
      response.body.to_s
    end

    private

    attr_reader :api_secret, :api_key

    def calculate_signature(options)
      args_sorted  = options.sort
      args_contact = args_sorted.map { |k, v| "#{k}=#{v}" }.join

      Digest::MD5.hexdigest(args_contact + api_secret)
    end
  end
end
