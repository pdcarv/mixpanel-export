require 'spec_helper'

describe MixpanelExport::EventProperties do
  subject(:events) { MixpanelExport::EventProperties.new('api_secret', 'api_key') }
  let!(:expire_date) { Time.now }

  before do
    Time.stub(:now).and_return(expire_date)
  end

  describe "#properties" do
    let(:response) do
      { 'data':
        { 'series': ['2010-05-29',
                     '2010-05-30',
                     '2010-05-31',
                     ],
          'values': {
            'splash features': {
              '2010-05-29': 6,
              '2010-05-30': 4,
              '2010-05-31': 5,
            }
          }
        },
        'legend_size': 2
      }.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events/properties").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
      to_return(:status => 200, :body => "", :headers => {})

      expect(events.properties).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events/properties").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
      to_return(:status => 200, :body => response, :headers => {})

      expect(events.properties).to eq(response)
    end
  end

  describe "#top" do
    let(:response) do
      {'ad version': {'count': 295}, 'user type': {'count': 91}}.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events/properties/top").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
      to_return(:status => 200, :body => "", :headers => {})

      expect(events.top).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events/properties/top").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
      to_return(:status => 200, :body => response, :headers => {})

      expect(events.top).to eq(response)
    end
  end

  describe "#values" do
    let(:response) do
      ['male', 'female', 'unknown'].to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events/properties/values").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
      to_return(:status => 200, :body => "", :headers => {})

      expect(events.values).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events/properties/values").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca', expire: expire_date.to_i, format: :json }).
      to_return(:status => 200, :body => response, :headers => {})

      expect(events.values).to eq(response)
    end
  end
end
