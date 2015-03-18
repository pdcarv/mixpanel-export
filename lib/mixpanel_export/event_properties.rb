module MixpanelExport
  class EventProperties < Base
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
