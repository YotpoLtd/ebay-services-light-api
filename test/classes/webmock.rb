require 'webmock/test_unit'
module WebMock
  def self.setup
    ebay_api_url = 'https://api.sandbox.ebay.com/ws/api.dll'
    #fixtures_path = File.expand_path(Dir.pwd) + '/fixtures/'


    #re = Regexp.union([/((?!shop_token)\s)*/])
    stub_request(:post, ebay_api_url).with(:body => /((?!shop_token)\s)*/).to_return(:body => ApiTest.load_fixture('invalid_token'))
    stub_request(:post, ebay_api_url).with(:body => /<GetUserRequest/).to_return(:body => ApiTest.load_fixture('user'))
    stub_request(:post, ebay_api_url).with(:body => /<GetOrdersRequest/).to_return(:body => ApiTest.load_fixture('orders'))
    stub_request(:post, ebay_api_url).with(:body => /<GeteBayOfficialTimeRequest/).to_return(:body => ApiTest.load_fixture('time'))
    stub_request(:post, ebay_api_url).with(:body => /<GetStoreRequest/).to_return(:body => ApiTest.load_fixture('store'))
    stub_request(:post, ebay_api_url).with(:body => /<GetItemRequest/).to_return(:body => ApiTest.load_fixture('item'))



  end
end