$:.unshift File.expand_path('../../test', __FILE__)  unless $:.include? File.expand_path('../../test', __FILE__)
require 'test_helper'
#require File.expand_path('test_helper')

class ApiTest < Test::Unit::TestCase
  def setup
    WebMock.setup
    @shop_token = 'shop_token'
    @ebay_api = EbayServicesLightApi::Api.new(@shop_token)
    EbayServicesLightApi.configure do |config|
      config.app_id= 'my_ebay_app_token'
      config.api_url = 'https://api.sandbox.ebay.com/ws/api.dll'
      config.dev_id = 123
      config.cert_id = "adsn123"
      config.ru_name = "Yotpo-1231ja"
    end
  end

  def test_prepera_body_should_push_attributes_in_nested_nodes_and_root_nodes
    request_attributes = {
        'CreateTimeFrom' => Time.now.to_s,
        'CreateTimeTo' => 'some other time',
        'PageNumber' => 34.to_s,
        'DetailLevel' => 'good_level',
        'EntriesPerPage' => 12.to_s
        }
    body_string = @ebay_api.prepare_body(:get_orders, request_attributes)
    response = Hash.from_xml(body_string.to_s)
    assert_equal request_attributes['CreateTimeFrom'],  response['GetOrdersRequest']['CreateTimeFrom']
    assert_equal request_attributes['CreateTimeTo'],  response['GetOrdersRequest']['CreateTimeTo']
    assert_equal request_attributes['PageNumber'],  response['GetOrdersRequest']['Pagination']['PageNumber']
    assert_equal request_attributes['DetailLevel'],  response['GetOrdersRequest']['DetailLevel']
    assert_equal request_attributes['EntriesPerPage'],  response['GetOrdersRequest']['Pagination']['EntriesPerPage']
  end

  def test_should_return_orders
    assert_nothing_raised do
      orders = @ebay_api.get_orders(Time.now)
      expected = Hash.from_xml(ApiTest.load_fixture('orders'))
      assert_equal expected['GetOrdersResponse'] , orders
    end
  end

  def test_should_get_user
    assert_nothing_raised do
      user = @ebay_api.get_user
      expected = Hash.from_xml(ApiTest.load_fixture('user'))
      assert_equal expected['GetUserResponse'] , user
    end
  end

  def test_should_get_time
    assert_nothing_raised do
      time = @ebay_api.get_time
      expected = Hash.from_xml(ApiTest.load_fixture('time'))
      assert_equal expected['GeteBayOfficialTimeResponse'] , time
    end
  end

  def test_should_get_store
    assert_nothing_raised do
      store = @ebay_api.get_store
      expected = Hash.from_xml(ApiTest.load_fixture('store'))
      assert_equal expected['GetStoreResponse'] , store
    end
  end

  def test_should_get_item
    assert_nothing_raised do
      item = @ebay_api.get_product 110117789239
      expected = Hash.from_xml(ApiTest.load_fixture('item'))
      assert_equal expected['GetItemResponse'] , item
    end
  end

  #def test_raises_appropriate_error_when_invalid_token
  #  invalid_token_ebay_api = EbayServicesLightApi::Api.new('invalid shop token')
  #  assert_raise EbayServicesLightApi::Exceptions::InvalidTokenError do
  #    invalid_token_ebay_api.get_time
  #  end
  #end

  def test_raises_appropriate_error_when_no_store

  end

  def test_raises_basic_error_when_unidentified_error

  end


end

