module EbayServicesLightApi
  class Verifier

    def self.authenticate(signature, token_val)
      cert = File.read(File.expand_path('../../conf/ebay_public_cert.txt', __FILE__))
      certificate = OpenSSL::X509::Certificate.new cert
      p_key = OpenSSL::PKey::RSA.new(certificate.public_key)

      return  p_key.verify(OpenSSL::Digest::SHA1.new, Base64.decode64(signature), token_val)
    end
  end
end

