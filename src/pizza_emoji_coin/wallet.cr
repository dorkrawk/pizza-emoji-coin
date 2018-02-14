require "cox"

class PizzaEmojiCoin::Wallet
  include NodeMixin

  getter public_key, private_key, cox_public_key, cox_private_key

  @cox_public_key : Cox::SignPublicKey
  @cox_private_key : Cox::SignSecretKey
  @public_key : String
  @private_key : String

  def initialize(public_key : Cox::SignPublicKey, private_key : Cox::SignSecretKey)
    key_pair = Cox::SignKeyPair.new(public_key, private_key)
    @cox_public_key = key_pair.public
    @cox_private_key = key_pair.secret
    @public_key = @cox_public_key.bytes.hexstring
    @private_key = @cox_private_key.bytes.hexstring
  end

  def self.new
    key_pair = Cox::SignKeyPair.new
    new(key_pair.public, key_pair.secret)
  end

  def self.new(public_key : String, private_key : String)
    public_key_bytes = public_key.hexbytes?
    raise "bad" unless public_key_bytes
    cox_public_key = Cox::SignPublicKey.new(public_key_bytes)

    private_key_bytes = private_key.hexbytes?
    raise "bad" unless private_key_bytes
    cox_private_key = Cox::SignSecretKey.new(private_key_bytes)

    new(cox_public_key, cox_private_key)
  end

  def sign(message)
    cox_signature = Cox.sign_detached(message, cox_private_key)
    cox_signature.hexstring
  end

  def verify(signature, message, public_key = "")
    verify_public_key = cox_public_key
    if !public_key.empty?
      public_key_bytes = public_key.hexbytes?
      raise "bad" unless public_key_bytes
      verify_public_key = Cox::SignPublicKey.new(public_key_bytes)
    end
    Cox.verify_detached(signature.hexbytes.to_slice, message, verify_public_key)
  end

  def get_balance
  end

  def get_transaction_history
  end

  def create_transaction(to, amount, fee)
    transaction = PizzaEmojiCoin::Transaction.new(
      public_key,
      to,
      amount,
      fee
    )
    transaction.sign(cox_private_key)
    # broadcast the transaction
  end
end
