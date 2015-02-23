module MixpanelExport
  class Events
    attr_reader :request

    def initialize(api_secret, api_key)
      @request = MixpanelExport::Request.new(api_secret, api_key)
    end

    def all(options={})
      options[:unit] = options[:unit] || "month"
      request.get('/events', options)
    end

    def top(options={})
      request.get('/top', options)
    end

    def names(options={})
      request.get('/names', options)
    end
  end
end
