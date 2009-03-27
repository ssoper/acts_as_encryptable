require File.dirname(__FILE__) + '/../test_helper'

class CryptoTest < Test::Unit::TestCase
  
  def setup
    @text = "I am a secret"
    @public_key = File.join(File.dirname(__FILE__), '/../../sample_keys/rsa_key.pub')
    @private_key = File.join(File.dirname(__FILE__), '/../../sample_keys/rsa_key')
  end
  
  def test_encryption
    public_key = ActsAsEncryptable::Crypto::Key.from_file(@public_key)
    encrypted = public_key.encrypt(@text)
    assert encrypted != @text
  end
  
  def test_decryption
    public_key = ActsAsEncryptable::Crypto::Key.from_file(@public_key)
    private_key = ActsAsEncryptable::Crypto::Key.from_file(@private_key)
    encrypted = public_key.encrypt(@text)
    assert @text == private_key.decrypt(encrypted)
  end

end
