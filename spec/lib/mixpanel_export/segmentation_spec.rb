require 'spec_helper'

describe MixpanelExport::Segmentation do
  subject(:events) { MixpanelExport::Segmentation.new('api_secret', 'api_key') }

  describe "#segmentation" do
    let(:response) do
      {'data': {'series': ['2011-08-08',
                    '2011-08-09',
                    '2011-08-06',
                    '2011-08-07'],
         'values': {'signed up': {'2011-08-06': 147,
                                  '2011-08-07': 146,
                                  '2011-08-08': 776,
                                  '2011-08-09': 1376}}},
      'legend_size': 1}.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.segmentation).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.segmentation).to eq(response)
    end
  end

  describe "#numeric" do
    let(:response) do
      {'data': {'series': ['2011-08-08',
              '2011-08-09',
              '2011-08-06',
              '2011-08-07'],
        'values': {'2,000 - 2,100': {'2011-08-06': 1,
                                '2011-08-07': 5,
                                '2011-08-08': 4,
                                '2011-08-09': 15},
              '2,100 - 2,200': {'2011-08-07': 2,
                                '2011-08-08': 7,
                                '2011-08-09': 15},
              '2,200 - 2,300': {'2011-08-06': 1,
                                '2011-08-08': 6,
                                '2011-08-09': 5},
              '2,300 - 2,400': {'2011-08-06': 4,
                                '2011-08-08': 1,
                                '2011-08-09': 12},
              '2,400 - 2,500': {'2011-08-08': 2,
                                '2011-08-09': 5}}},
      'legend_size': 5}.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation/numeric").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.numeric).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation/numeric").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.numeric).to eq(response)
    end
  end

  describe "#sum" do
    let(:response) do
      {'results': {'2011-08-06': 376.0,
            '2011-08-07': 634.0,
            '2011-08-08': 474.0,
            '2011-08-09': 483.0},
      'status': 'ok'}.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation/sum").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.sum).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation/sum").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.sum).to eq(response)
    end
  end

  describe "#average" do
    let(:response) do
      {'results': {'2011-08-06': 8.64705882352939,
            '2011-08-07': 4.640625,
            '2011-08-08': 3.6230899830221,
            '2011-08-09': 7.3353658536585},
      'status': 'ok'}.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation/average").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.average).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/segmentation/average").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.average).to eq(response)
    end
  end
end
