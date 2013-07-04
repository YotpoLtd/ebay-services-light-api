require 'rubygems'
require 'test/unit'
require 'active_support/core_ext/hash'
require 'classes/webmock'
$:.unshift File.expand_path('../../lib', __FILE__) unless $:.include? File.expand_path('../../lib', __FILE__)
require 'ebay-services-light-api.rb'
class Test::Unit::TestCase
  include WebMock

  def self.load_fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}.xml")
  end
end

