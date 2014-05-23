require 'rubygems'
require 'pry'

class Card
  attr_accessor :suit, :value

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def pretty_output
    puts "#{value} of #{suit}"
  end


  def to_s      
    pretty_output
  end

  def find_suit
    case suit
      when 'C' then 'Clubs'
      when 'D' then 'Diamonds'
      when 'H' then 'Hearts'
      when 'S' then 'Spades'
    end
  end

end


class Deck
  attr_accessor :cards

  def initialize
    @cards = []     # instantiate an array of cards each time
    [2,3,4,5,6,7,8,9,10,'J','Q','K','A'].each do |value|
      ['Clubs','Diamonds','Hearts','Spades'].each do |suit| 
        @cards.push(Card.new(value, suit))                      # [2, 'Clubs'] --> ['A', 'Spades']
      end
    end
    scramble
  end

  def scramble
    cards.shuffle!
  end

  def deal_card        # why put deal_card-method in Deck class? What would happen if in User class, and how to implement?
    cards.pop
  end

  def size
    cards.size
  end

end


# is-a vs has-a relationship. Dealer/player == which one?
  # is-a is used to model subcategories (Dog < Animal), uses inheritance of behaviors from super-classes
  # has-a r/s == leads to Composition. Injecting behavior into a class w/ a MODULE. Include behavior in other classes using modules.
    # Both dealer and player have similar behaviors
    # Mixing in a module - multiple inheritance


module Hand       # for common behaviors, include in Dealer and Player
  #
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do |card|
      puts "=> #{card.to_s}"
    end
    puts "=>Total: #{calc_total}"
  end
  #
  #
  def calc_total
    face_values = cards.map{ |card| card.value }

    hand_total = 0
    face_values.each do |value|
      if value == 'A'
        hand_total += 11
      else
        hand_total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    face_values.select{ |value| value == 'A' }.count.times do
      break if hand_total <= 21
      hand_total -= 10
    end

    hand_total
  end
  #                               # adding to cards-array
  def add_card(new_card)          # this will incorporate the deal-method from Deck class. Adding to player/dealer cards-array
    cards << new_card                     # 14:16: once the instance method has been added to the class, the module method has access to the Class instance variables/getters
  end                                         # so any class that includes this module will need to have an array ready and waiting to hold cards...
  #

end


# most of the functionality is going to be in the module, as opposed to in the player/dealer classes...


class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(n)       # STATE: want to keep track of Player's: name, the cards he's holding, total
    @name = n
    @cards = []           # initialize w/ an empty array cuz not giving cards when we create the player, but it happens later on (via method)
  end
end



class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end


#--------------------

class Blackjack
  attr_accessor :deck, :player, :dealer   # @(6:45)

  def initialize
    @deck = Deck.new
    @player = Player.new('Player name')
    @dealer = Dealer.new     # (!!)
  end

  def set_player_name
    puts "Welcome to Blackjack. What's your name?"
    player.name = gets.chomp                        # @(6:45) -> now, when use player here, it refers to the attr_accessor-getter method, which returns the instance variable @player initialized...
  end                                               #       ... (!!) which refers to object of class player. In player class, have a name-getter...


  def player_deal_card
    player.add_card(deck.deal_card)
    player.add_card(deck.deal_card)
    player.show_hand
  end

  def dealer_deal_card
    dealer.add_card(deck.deal_card)
    dealer.show_hand
    dealer.add_card(deck.deal_card)
  end



  def flop_blackjack
    if (dealer.calc_total == 21) && (player.calc_total == 21)
      puts "*****You got blackjack, but so did the Dealer. PUSH!*****"
      play_again?
    elsif dealer.calc_total == 21
      puts "*****Dealer has BLACKJACK! Sorry #{player.name}, you lose!*****"
      dealer.show_hand
      play_again?
    elsif player.calc_total == 21
      puts "*****You got BLACKJACK! You win #{player.name}!*****"
      play_again?
    end
  end

  def player_turn
    puts "-----------------"
    puts "****Your Move****"
    puts "-----------------"
    puts "#{player.name}, enter 'h' to hit or 's' to stay..."
    answer = gets.chomp

    while answer == 'h'
      player_new_card = deck.deal_card
      player.add_card(player_new_card)
      puts ">> You hit and get a..."
      player_new_card_vis = player_new_card.pretty_output
      player.show_hand

      if player.calc_total  <= 21
        puts "Enter 'h' to hit or 's' to stay..."
        answer = gets.chomp
      elsif player.calc_total > 21
        puts "*****You busted with #{player.calc_total}... You LOSE!*****"
        play_again?
      end
    end

    if answer == 's'
      puts '---------'
    end
  end


  def dealer_turn
    puts "--------------"
    puts "*Dealer's Turn*"
    puts "--------------"
    puts "Dealer's 2 cards are..."
    dealer.show_hand 

    while dealer.calc_total <= 16
      new_card = deck.deal_card              # .to_s in the right position???
      puts ">> Dealer hits and gets a..."
      new_card_vis = new_card.pretty_output
      dealer.add_card(new_card)
      dealer.show_hand
      puts "------------"
    end
  end

  def who_won
    if (player.calc_total > dealer.calc_total) && (player.calc_total <= 21)
      puts "*****You WIN!*****"
    elsif (player.calc_total > dealer.calc_total)
      puts "*****You WIN!*****"
    elsif (dealer.calc_total > player.calc_total) && (dealer.calc_total <= 21)
      puts "*****You LOSE!*****"
    elsif player.calc_total == dealer.calc_total
      puts "*****PUSH!*****"
    end
  end

  def play_again?
    puts ""
    puts "Do you wanna play again or nah? Enter 'y' for yes or 'n' for no"
    if gets.chomp == 'y'
      puts "New game loading..."
      deck = Deck.new             # Need to reset to brand new deck, cuz it had decreased in amount
      player.cards = []
      dealer.cards = []
      start
    else
      puts "It's been real..."
      exit
    end
  end

  def start
    set_player_name
    player_deal_card
    dealer_deal_card
    flop_blackjack
    player_turn
    dealer_turn
    who_won
    play_again?
  end


end

game = Blackjack.new
game.start

