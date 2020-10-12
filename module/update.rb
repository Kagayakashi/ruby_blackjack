# frozen_string_literal: true

module Update
  private

  @logs = []

  def update
    send(@state)
  end

  def player_skip; end

  def player_open; end

  def player_draw
    card, value = @deck.next_card
    value += 10 if card.include?('A') && @player.score + value < 21
    @player.add_card(card, value)

    @logs << "#{@player.name.capitalize} взял одну карту."
  end

  def dealer_turn
    dealer_draw if @dealer.score < DEALER_MAX_SCORE
  end

  def dealer_draw
    card, value = @deck.next_card
    value += 10 if card.include?('A') && @dealer.score + value < 21
    @dealer.add_card(card, value)
    @logs << "#{@dealer.name.capitalize} взял одну карту."
  end

  def update_player_score
    score = 0
    @player.hand.each { |_card, value| score += value }
    @player.score = score
  end

  def update_dealer_score
    score = 0
    @dealer.hand.each { |_card, value| score += value }
    @dealer.score = score
  end
end
