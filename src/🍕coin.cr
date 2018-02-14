require "./pizza_emoji_coin/*"

class PizzaEmojiCoin::Runner

  def test
    🍕transaction = PizzaEmojiCoin::Transaction.new("source", "destination", 1337, 42, "signature")


    🍕wallet = PizzaEmojiCoin::Wallet.new
    puts 🍕wallet.public_key
    puts 🍕wallet.private_key

    🍕wallet2 = PizzaEmojiCoin::Wallet.new
    puts 🍕wallet2.public_key
    puts 🍕wallet2.private_key

    🍕transaction = PizzaEmojiCoin::Transaction.new(🍕wallet.public_key, 🍕wallet2.public_key, 1337, 42)
    🍕transaction.sign!(🍕wallet.private_key)



    puts 🍕transaction.verified?

    puts 🍕transaction.transaction_kv

    puts "🍕"
  end
end

PizzaEmojiCoin::Runner.new.test
