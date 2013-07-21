module EbayServicesLightApi
  # Configures Plugin.
  def self.configure(configuration = EbayServicesLightApi::Configuration.new)
    yield configuration if block_given?
    @@configuration = configuration
  end

  def self.configuration
    @@configuration ||= EbayServicesLightApi::Configuration.new
  end

  class Configuration
    attr_accessor :api_url
    attr_accessor :app_id
    attr_accessor :dev_id
    attr_accessor :cert_id
    attr_accessor :ru_name
    attr_accessor :base_signin_url
  end

end