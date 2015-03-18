module MixpanelExport
  class Events < Base
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
