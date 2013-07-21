module EbayServicesLightApi
  class Api

    CONF = YAML.load_file(File.expand_path('../../conf/conf.yml', __FILE__))

    def initialize(auth_token=nil)
      @auth_token = auth_token
    end

    def subscription_success_response(subscription_id)
      return prepare_body(:success_response, {"timestamp" => DateTime.now, "subscriptionId" => subscription_id})
    end

    def subscription_error_response(subscription_id, message = nil)
      return prepare_body(:error_response, {"timestamp" => DateTime.now, "subscriptionId" => subscription_id, "message" => (message || 'Subscription Failure')})
    end

    def unsubscription_success_response
      return prepare_body(:remove_subscriber_success_response, {"timestamp" => DateTime.now})
    end

    def prepare_body(call_name, params={})
      params['eBayAuthToken'] = @auth_token if @auth_token
      doc = Nokogiri::XML(File.read(File.expand_path("../../requests/#{call_name}.xml", __FILE__)))

      params.each do |k, v|
        doc.search(k).each do |node|
          node.content = v
        end
      end

      return doc.to_s
    end

    def ebay_request(call_name, body)
      headers = CONF['HEADERS']
      headers['X-EBAY-API-CALL-NAME'] = call_name
      headers['X-EBAY-API-DEV-NAME'] = EbayServicesLightApi.configuration.dev_id
      headers['X-EBAY-API-APP-NAME'] = EbayServicesLightApi.configuration.app_id
      headers['X-EBAY-API-CERT-NAME'] = EbayServicesLightApi.configuration.cert_id

      request = Typhoeus::Request.new(EbayServicesLightApi.configuration.api_url, :method => :post, :body => body, :headers => headers)
      begin
        request.run
      rescue Exception => e
      end

      raw_response = request.response.response_body
      xml_respone = Nokogiri::XML raw_response
      result = Hash.from_xml(xml_respone.to_s)
      result = result["#{call_name}Response"]
      if result["Ack"] == 'Failure'
        #handle error
        if result["Errors"].class == Hash
          raise Exceptions::NoStoreError if result["Errors"]["ErrorCode"] == '13003'#error code for user with no store subscription
          raise Exceptions::InvalidTokenError if result["Errors"]["ErrorCode"] == '931'#error code for user with invalid token
        end
        raise Exceptions::BasicError
      end
      return result
    end

    def get_product(product_id)
      body = prepare_body(:get_item, {"ItemID" => product_id})
      return ebay_request("GetItem", body)
    end

    def get_orders(start_date, page=1)
      body = prepare_body(:get_orders, {"PageNumber" => page, "CreateTimeFrom" => start_date.to_s, "CreateTimeTo" =>  DateTime.now.to_s})
      return ebay_request("GetOrders", body)
    end

    def get_user
      body = prepare_body(:get_user)
      return ebay_request("GetUser", body)
    end

    def get_store
      body = prepare_body(:get_store)
      return ebay_request("GetStore", body)
    end

    def get_time
      body = prepare_body(:get_time)
      return ebay_request("GeteBayOfficialTime", body)
    end

    def set_store_custom_page(page_data = {})
      body = prepare_body(:set_store_custom_page, {"Content" => page_data[:content] || '', "Name" => page_data[:name] || '', "Status" => page_data[:status] || 'Active', "LeftNav" => page_data[:left_nav] || 'true', "Order" => page_data[:order] || 3 || 'Active', "PreviewEnabled" => page_data[:preview_enabled] || 'true'})
      return ebay_request("SetStoreCustomPage", body)
    end

    def get_session_id
      body = prepare_body(:get_session_id, {"RuName" => EbayServicesLightApi.configuration.ru_name})
      result =  ebay_request("GetSessionID", body)
      return result["SessionID"]
    end

    def fetch_token(session_id)
      body = prepare_body(:fetch_token, {"SessionID" => session_id})
      result = ebay_request("FetchToken", body)
    end

    def self.get_signin_url(session_id)
      return "#{EbayServicesLightApi.configuration.base_signin_url}&RuName=#{EbayServicesLightApi.configuration.ru_name}&SessID=#{session_id}"
    end

  end
end

