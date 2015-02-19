require 'spec_helper'

describe Mixpanel::Export::Events do
  subject(:events) { Mixpanel::Export::Events.new('api_secret', 'api_key') }

  describe "#all" do
    let(:response) do
      { 'data': {
          'series': ['2010-05-29', '2010-05-30', '2010-05-31'],
          'values': {'account-page': { '2010-05-30': 1, },
          'splash features': { '2010-05-29': 6,
                               '2010-05-30': 4,
                               '2010-05-31': 5, }
          }
      },
      'legend_size': 2 }.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca' }).
      to_return(:status => 200, :body => "", :headers => {})

      expect(events.all).to eq("")
    end

    it "return a json string if request succedeed" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca' }).
      to_return(:status => 200, :body => response, :headers => {})

      expect(events.all).to eq(response)
    end
  end

  describe "#top" do
    let(:response) do
      [ 'battle','click signup button','send message','View homepage'].to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/top").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca' }).
      to_return(:status => 200, :body => "", :headers => {})

      expect(events.top).to eq("")
    end

    it "return a json string if request succedeed" do
      stub_request(:get, "http://mixpanel.com/api/2.0/top").
      with(query: { api_key: 'api_key', sig: 'e720dfe014c0107e3f080b0880997bca' }).
      to_return(:status => 200, :body => response, :headers => {})

      expect(events.top).to eq(response)
    end
  end
end
