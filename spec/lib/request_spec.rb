require 'spec_helper'

describe MixpanelExport::Request do
  let(:request) { MixpanelExport::Request.new('api_secret', 'api_key') }
  let!(:expire_date) { Time.now }

  before do
    Time.stub(:now).and_return(expire_date)
  end

  describe "#get" do
    it "raises error if the request is not successful" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
        to_return(status: 400)

      expect { request.get('/events') }.to raise_exception(Net::HTTPServerException)
    end

    it "returns the request body if request succeeds" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
        to_return(status: 200, body: "{}")

      expect(request.get('/events')).to eq("{}")
    end

    it "requires a signature to be calculated" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
        to_return(status: 200, body: "{}")

      expect(request).to receive(:calculate_signature).once.and_return('e720dfe014c0107e3f080b0880997bca')
      request.get('/events')
    end
  end

  describe "#calculate_signature" do
    it "returns a valid signature" do
      options = { type: "average", event: ["splash features", "account-page"], unit: "day" }
      expect(request.send(:calculate_signature, options)).to eq('6f38868cc0000cd23b8223cd26c3426c')
    end
  end

  describe "#build_query" do
    it "should set an expire date if none provided" do
      expect(request.send(:build_query, {})).to include(expire: expire_date.to_i)
    end
  end
end
