$:.push File.expand_path("../lib", __FILE__)
require "ebay/version"
Gem::Specification.new do |s|
  s.name     = "ebay-services-light-api"
  s.version  = EbayServicesLightApi::VERSION
  s.date     = Time.now.strftime("%Y-%m-%d")
  s.summary  = "Enables Ruby applications to communicate with the Ebay Trading API"
  s.email    = "omri@yotpo.com"
  s.homepage = "https://github.com/YotpoLtd/ebay-services-light-api"
  s.description = "Enables Ruby applications to communicate with the Ebay Trading API."
  s.has_rdoc = false
  s.require_paths = ['lib']
  s.authors  = ["Yotpo/omri@yotpo"]
  s.files = ["Rakefile", "README.md", "ebay-services-light-api.gemspec"] + Dir['**/*.rb'] + Dir['**/*.crt']
  s.add_dependency 'typhoeus'
  s.add_dependency 'nokogiri'
  s.add_development_dependency 'active_support'
  s.add_development_dependency "webmock"
  s.add_development_dependency "mocha"

end
