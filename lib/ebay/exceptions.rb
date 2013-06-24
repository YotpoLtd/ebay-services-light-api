module EbayEmbedded
  module EbayExceptions
    class NoStoreError        < StandardError; end
    class InvalidTokenError   < StandardError; end
    class BasicError          < StandardError; end
  end
end
