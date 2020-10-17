# frozen_string_literal: true

class Player
  attr_reader :name, :bank, :score, :hand

  def initialize(name, capital)
    @bank = capital
    @capital = capital
    @name = name.downcase.capitalize
    @hand = []
    @score = 0
  end

  def add_card(card)
    # Если текущая карта на выбор туз, то проверить есть ли он уже в колоде и пересчитать значение.
    if card.ace?
      ace = @hand.select(&:ace?)
      card.ace_value(ace.empty?)
    end

    @score += card.value
    @hand << card
  end

  def increase_bank(sum)
    @bank += sum
  end

  def decrease_bank(sum)
    @bank -= sum
    @bank = 0 if @bank.negative?
  end

  def reset_bank
    @bank = @capital
  end

  def drop
    @hand = []
    @score = 0
    @score = 0
  end

  def lost?
    @score > 21
  end
end
