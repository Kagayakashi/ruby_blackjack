# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'

class Game
  attr_reader :dealer, :player, :bank

  def initialize(player, dealer, capital)
    @player = Player.new(player, capital)
    @dealer = Player.new(dealer, capital)
  end

  def increase_bank(bet)
    @bank += bet
  end

  def player_draw
    card = @deck.next_card
    @player.add_card(card)
  end

  def dealer_draw
    return false if @dealer.score > 17

    card = @deck.next_card
    @dealer.add_card(card)
    true
  end

  def reset
    @deck = Deck.new
    @turn = 0
    @bank = 0
    @player.drop
    @dealer.drop
  end

  def hard_reset
    @player.reset_bank
    @dealer.reset_bank
  end

  def winner
    return nil if draw?
    return @player if player_won?
    return @dealer if dealer_won?
  end

  def player_won?
    return false if @player.lost? || !@dealer.lost? && @player.score < @dealer.score

    # Победа игрока
    true
  end

  def dealer_won?
    return false if @dealer.lost? || !@player.lost? && @dealer.score < @player.score

    # Победа дилера
    true
  end

  def draw?
    return false if @player.lost? || @dealer.lost? || @player.score != @dealer.score

    # Ничья
    true
  end
end
