require 'spec_helper'

describe MixpanelExport::Request do
  let(:request) { MixpanelExport::Request.new('api_secret', 'api_key') }

  describe "#get" do
    it "raises error if the request is not successful" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(status: 400)

      expect { request.get('/events') }.to raise_exception
    end

    it "returns the request body if request succeeds" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(status: 200, body: "{}")

      expect(request.get('/events')).to eq("{}")
    end

    it "requires a signature to be calculated" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(status: 200, body: "{}")

      expect(request).to receive(:calculate_signature).once.and_return('e720dfe014c0107e3f080b0880997bca')
      request.get('/events')
    end
  end

  describe "#calculate_signature" do
    it "returns a valid signature" do
      options = { api_key: "f0aa346688cee071cd85d857285a3464", interval: 7, type: "average", event: ["splash features<", "account-page"], unit: "day", expire: 1275624968, format: "json" }
      expect(request.send(:calculate_signature, options)).to eq('046ceec93983811dad0fb20f842c351a')
    end
  end

  describe "#build_query" do
    it "should set an expire date if none provided" do
      expire_date = Time.now.utc
      Time.stub(:now).and_return(expire_date)

      expect(request.send(:build_query, {})).to include(expire: (expire_date.to_i + 600))
    end
  end
end
