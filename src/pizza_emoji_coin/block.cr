class PizzaEmojiCoin::Block

  def initialize(@index : Int32, @transactions, @previous_hash : String, @timestamp = Time.now, nonce = 0)

  end
end
