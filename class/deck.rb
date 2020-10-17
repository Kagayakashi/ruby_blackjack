# frozen_string_literal: true

require_relative 'card'

class Deck
  attr_reader :list

  def initialize
    create_deck
  end

  def next_card
    @list = @list.shuffle
    card = @list.first
    @list.delete(card)
    card
  end

  def cards_left
    @list.count
  end

  private

  def create_deck
    @list = []

    # deck_digits
    deck_symbols
  end

  def deck_digits
    (2..10).each do |c|
      card = Card.new("#{c}♣", c)
      @list << card
      card = Card.new("#{c}♦", c)
      @list << card
      card = Card.new("#{c}♥", c)
      @list << card
      card = Card.new("#{c}♠", c)
      @list << card
    end
  end

  def deck_symbols
    symbols = {
      'A' => 1,
      'K' => 10,
      'Q' => 10,
      'J' => 10
    }

    symbols.each do |c, v|
      card = Card.new("#{c}♣", v)
      @list << card
      card = Card.new("#{c}♣", v)
      @list << card
      card = Card.new("#{c}♣", v)
      @list << card
      card = Card.new("#{c}♣", v)
      @list << card
    end
  end
end
