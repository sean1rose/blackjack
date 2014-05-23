# test comment
def begin_game
  
  puts "Welcome to the Blackjack Table. What's your name???"
  user_name = gets.chomp

  suits = ['of Clubs', 'of Diamonds', 'of Hearts', 'of Spades']
  cards = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']

  # Implemented concept of using product of 2 separate arrays (1 for suit, 1 for cards) from the 1st solution video.

  deck = cards.product(suits)
  deck.shuffle!

  user_total = 0
  dealer_total = 0

  def calculate_total(total, card)
    card_value = card[0]
    if card_value == 'Jack' || card_value == 'Queen' || card_value == 'King'    # if a face card
      card_value = 10
      total += card_value
      #total = total + card_value
    elsif card_value == 'Ace'         # if an Ace
      if total >= 11                  # if current total is already at 11 or higher, ace must equal 1
        card_value = 1
      else                            # if total is less than 11, ace equals 11
        card_value = 11
      end
      total += card_value
      #total = total + card_value    
    else                              # not an A or face card
      total += card_value
      #total = total + card_value
    end

  end

  puts ""

  user_first_card = deck.pop
  user_total = calculate_total(user_total, user_first_card)

  dealer_first_card = deck.pop
  dealer_total = calculate_total(dealer_total, dealer_first_card)
  puts ">>>Dealer shows one card, a #{dealer_first_card}."

  user_second_card = deck.pop
  user_total = calculate_total(user_total, user_second_card)
  puts "#{user_name}, your 1st two cards are a #{user_first_card} and a #{user_second_card} for a TOTAL of #{user_total}."

  dealer_second_card = deck.pop
  dealer_total = calculate_total(dealer_total, dealer_second_card)


  if user_total == 21
    puts "BLACKJACK! You WIN #{user_name} :)"
    exit
  end

  if dealer_total == 21
    puts "Dealer has BLACKJACK! Sorry #{user_name}, you LOSE :("
    exit
  end

  puts ''

  puts "#{user_name}, enter 'h' to Hit or 's' to Stay..."
  answer = gets.chomp


  while answer == 'h'
    new_card = deck.pop
    puts "You've been dealt a #{new_card}."
    user_total = calculate_total(user_total, new_card)

    if user_total <= 21
      puts "You now have #{user_total}."
      puts "Enter 'h' to Hit or 's' to Stay..."
      answer = gets.chomp
    elsif user_total > 21
      puts "You Bust with #{user_total}! You LOSE #{user_name}!"
      break
    end   
  end


  if answer == 's'
    puts ""
    puts "Dealer's other card is a #{dealer_second_card}. So Dealer has a total of #{dealer_total}."
    
    while dealer_total <= 16
      new_dealer_card = deck.pop
      dealer_total = calculate_total(dealer_total, new_dealer_card)
      puts "Dealer hits and is dealt a #{new_dealer_card}. Dealer now has a TOTAL of #{dealer_total}."
      puts ""

      if dealer_total > 21
        puts "Dealer BUST! You WIN #{user_name}!"
      elsif dealer_total > 16 && dealer_total <= 21
        puts "Dealer has #{dealer_total}."
      end
    end

  end


  puts "#{user_name}, you have #{user_total} and Dealer has #{dealer_total}."

  if (user_total > dealer_total) && (user_total <= 21)
    puts "You WIN!"
  elsif (dealer_total > user_total) && (dealer_total <= 21)
    puts "You LOSE!"
  elsif user_total == dealer_total
    puts "PUSH"
  end


puts ""
puts "Would you like to play again or nah???"
puts "Enter 'y' if yes or 'n' if no..."
response = gets.chomp

if response == 'y'
  begin_game
end

end

begin_game






