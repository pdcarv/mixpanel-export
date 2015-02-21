module Mixpanel
  module Export
    class EventProperties
      attr_reader :request

      def initialize(api_secret, api_key)
        @request = Mixpanel::Request.new(api_secret, api_key)
      end

      def properties(options={})
        request.get('/events/properties', options)
      end

      def top(options={})
        request.get('/events/properties/top', options)
      end

      def values(options={})
        request.get('/events/properties/values', options)
      end
    end
  end
end
