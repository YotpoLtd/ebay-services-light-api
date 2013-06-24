require 'fake_web'

module FakeWeb
  FakeWeb.allow_net_connect = false

  get_orders_url = "http://www.google.com"
  get_user_url = "http://www.google.com"
  get_time_successful_url = "http://www.google.com"
  get_time_invalid_token = "http://www.google.com"
  get_store_successful_url = "http://www.google.com"
  get_store_failure_url = "http://www.google.com"
  get_item_url = "http://www.google.com"

  xml_orders = File.read(File.dirname(__FILE__) + "/fixtures/orders.xml")
  xml_item = File.read(File.dirname(__FILE__) + "/fixtures/item.xml")
  xml_user = File.read(File.dirname(__FILE__) + "/fixtures/user.xml")
  xml_store = File.read(File.dirname(__FILE__) + "/fixtures/store.xml")
  xml_no_store = File.read(File.dirname(__FILE__) + "/fixtures/no_store.xml")
  xml_invalid_token = File.read(File.dirname(__FILE__) + "/fixtures/invalid_token.xml")
  xml_time = File.read(File.dirname(__FILE__) + "/fixtures/time.xml")

  FakeWeb.register_uri(:get, get_orders_url, :body => xml_orders, :parameters => {:p1 => 'v1'})
  FakeWeb.register_uri(:get, get_user_url, :body => xml_user, :parameters => {:p1 => 'v1'})
  FakeWeb.register_uri(:get, get_time_successful_url, :body => xml_time, :parameters => {:p1 => 'v1'})
  FakeWeb.register_uri(:get, get_time_invalid_token, :body => xml_invalid_token, :parameters => {:p1 => 'v1'})
  FakeWeb.register_uri(:get, get_store_successful_url, :body => xml_store, :parameters => {:p1 => 'v1'})
  FakeWeb.register_uri(:get, get_store_failure_url, :body => xml_no_store, :parameters => {:p1 => 'v1'})
  FakeWeb.register_uri(:get, get_item_url, :body => xml_item, :parameters => {:p1 => 'v1'})

end