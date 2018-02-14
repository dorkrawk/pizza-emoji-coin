require "openssl"
require "cox"

class PizzaEmojiCoin::Transaction

  # JSON.mapping(
  #   source: String,
  #   destination: String,
  #   amount: Int32,
  #   fee: Int32,
  #   signature: String,
  #   timestamp: Time,
  #   tx_hash: String
  # )

  property source, destination, amount, fee, signature, timestamp, tx_hash

  def initialize(@source : String, @destination : String, @amount : Int32, @fee : Int32, @signature : String = "")
    @timestamp = Time.now
    @tx_hash = @signature ? calculate_tx_hash : ""
  end

  def calculate_tx_hash
    # Return a hash of the Transaction based on
    # - source
    # - destination
    # - amount
    # - fee
    # - timestamp
    # - signature

    digest = OpenSSL::Digest.new("SHA256")
    digest << transaction_kv.to_s
    digest.to_s
  end

  def sign!(source_private_key : String)
    cox_source_private_key = Cox::SignSecretKey.new(source_private_key.hexbytes.to_slice)
    cox_signature = Cox.sign_detached(signable, cox_source_private_key)
    @signature = cox_signature.hexstring
    @tx_hash = calculate_tx_hash
    @signature
  end

  def verified?
    return false unless signature
    cox_source = Cox::SignPublicKey.new(source.hexbytes.to_slice)
    Cox.verify_detached(signature.hexbytes.to_slice, signable, cox_source)
  end

  def transaction_kv
    {
      "source" => source,
      "destination" => destination,
      "amount" => amount,
      "fee" => fee,
      "timestamp" => timestamp,
      "signature" => signature
    }
  end

  def signable
    [source, destination, amount, fee, timestamp].join("|")
  end

  def cox_source
    source_bytes = source.hexbytes?
    raise "bad" unless source_bytes
    Cox::PublicKey.new(source_bytes)
  end

  def cox_destination
    destination_bytes = destination.hexbytes?
    raise "bad" unless destination_bytes
    Cox::PublicKey.new(destination_bytes)
  end
end
