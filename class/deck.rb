# frozen_string_literal: true

class Deck
  attr_reader :list

  def initialize
    create_deck
  end

  def next_card
    @list = @list.to_a.shuffle.to_h
    card = @list.keys[0]
    value = @list[card]
    @list.delete(card)

    [card, value]
  end

  def cards_left
    @list.count
  end

  private

  def create_deck
    @list = {}

    deck_digits
    deck_symbols
  end

  def deck_digits
    (2..10).each do |c|
      @list["#{c}♣"] = c
      @list["#{c}♦"] = c
      @list["#{c}♥"] = c
      @list["#{c}♠"] = c
    end
  end

  def deck_symbols
    symbols = { 'A' => 1,
                'K' => 10,
                'Q' => 10,
                'J' => 10 }

    symbols.each do |c, v|
      @list["#{c}♣"] = v
      @list["#{c}♦"] = v
      @list["#{c}♥"] = v
      @list["#{c}♠"] = v
    end
  end
end
