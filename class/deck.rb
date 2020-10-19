# frozen_string_literal: true

require_relative 'card'

class Deck
  C_SUITS = ['♣', '♦', '♥', '♠'].freeze
  C_NUMBERS = (2..10).freeze
  C_SYMBOLS = %w[A K Q J].freeze
  C_SYMBOL_VALUE = 10

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

    deck_numbers
    deck_symbols
  end

  def deck_numbers
    C_SUITS.each do |suit|
      C_NUMBERS.each do |value|
        card = Card.new("#{value}#{suit}", value)
        @list << card
      end
    end
  end

  def deck_symbols
    C_SUITS.each do |suit|
      C_SYMBOLS.each do |symbol|
        card = Card.new("#{symbol}#{suit}", C_SYMBOL_VALUE)
        @list << card
      end
    end
  end
end
