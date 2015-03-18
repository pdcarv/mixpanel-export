module MixpanelExport
  class Base
    attr_reader :request

    def initialize(api_secret, api_key)
      @request = MixpanelExport::Request.new(api_secret, api_key)
    end
  end
end
