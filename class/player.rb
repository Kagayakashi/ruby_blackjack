# frozen_string_literal: true

class Player
  attr_reader :name, :bank, :score, :hand

  I_START_CAPITAL = 100

  def initialize(name)
    @bank = I_START_CAPITAL
    @name = name.downcase.capitalize
    @hand = {}
    @score = 0
  end

  def add_card(card, value)
    @hand[card] = value
  end

  def increase_bank(sum)
    @bank += sum
  end

  def decrease_bank(sum)
    @bank -= sum
    @bank = 0 if @bank.negative?
  end

  def reset_bank
    @bank = 100
  end

  attr_writer :score

  def drop
    @hand = {}
  end

  def lost?
    @score > 21
  end

  def puts_cards
    print "Карты #{@name}: "
    c = 0
    @hand.each do |card, _value|
      c += 1
      print card.to_s
      print ', ' if c < @hand.count
    end
    puts
  end
end
