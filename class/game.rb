# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'

class Game
  attr_reader :dealer, :player, :bank

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

  def create_player(name, capital)
    @player = Player.new(name, capital)
  end

  def create_dealer(name, capital)
    @dealer = Player.new(name, capital)
  end
end
