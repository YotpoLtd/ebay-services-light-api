module EbayServicesLightApi

  class Decrypter

    def self.decrypt(encoded_msg)
      hmac_key, cipher_key = self.get_keys(EbayServicesLightApi.configuration.app_token)

      msg = Base64.decode64(encoded_msg)

      hmac_received = msg[(msg.length - 20)..-1]

      #capture the rest of the bytes into cipherBytes
      cipher_bytes = msg[0..(msg.length - 21)]

      #use HMACSHA1 to verify the integrity of the message
      actual = OpenSSL::HMAC.digest('sha1',hmac_key, cipher_bytes)
      # $actual = hash_hmac("sha1", $cipherBytes, $hmacKey, true);
      raise 'HMAC verification failure' unless actual == hmac_received

      #if we made it to here, the raw message is valid; decrypt the message

      init_vect = cipher_bytes[0..16]
      crypted   = cipher_bytes[16..-1]

      cipher = OpenSSL::Cipher.new('aes-128-cbc')
      cipher.decrypt
      cipher.key = cipher_key
      cipher.iv = init_vect

      decrypted_message = '' << cipher.update(crypted) << cipher.final
      return decrypted_message
    end

    #create cipher key and hmac key as instructed by Ebay documentation
    def self.get_keys(master_key)
      base_hmac = "\1#{master_key}"
      hmac_key = Digest::SHA1.digest base_hmac

      base_cipher = "\0#{master_key}"
      cipher_key = Digest::SHA1.digest(base_cipher)[0..15]
      return [hmac_key, cipher_key]
    end

  end
end

