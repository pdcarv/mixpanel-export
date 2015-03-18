module MixpanelExport
  class Segmentation < Base
    def segmentation(options={})
      request.get('/segmentation', options)
    end

    def numeric(options={})
      request.get('/segmentation/numeric', options)
    end

    def sum(options={})
      request.get('/segmentation/sum', options)
    end

    def average(options={})
      request.get('/segmentation/average', options)
    end
  end
end
