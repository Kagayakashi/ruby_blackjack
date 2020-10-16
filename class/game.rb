# frozen_string_literal: true

require_relative 'player'
require_relative 'deck'

class Game

  FIRST_BET = 10
  MAX_SCORE_DEALER = 17
  WIN_SCORE = 21
  MAX_TURNS = 3
  A_CARD_BONUS = 10

  def initialize
    reset
  end

  def create_player(name)
    @player = Player.new(name)
  end
  
  def create_dealer(name)
    @dealer = Player.new(name)
  end
 
  def new_turn
    @turn += 1 if @turn < MAX_TURNS
  end
 
  def next_turn
    first_draw if @turn.zero?
    
    dealer_draw if @turn == 2

    new_turn
  end

  def first_draw
    puts "\nНачало новой партии."
    
    @player.decrease_bank(FIRST_BET)
    @dealer.decrease_bank(FIRST_BET)
    @bank += FIRST_BET + FIRST_BET

    player_draw
    player_draw

    dealer_draw
    dealer_draw
    
    new_turn
  end
    
  def open_cards
    @turn = MAX_TURNS
  end  

  def player_draw
    card, value = @deck.next_card
    value += A_CARD_BONUS if card.include?('A') && @player.score + value < WIN_SCORE
    @player.add_card(card, value)

    puts "#{@player.name} взял одну карту."
  end

  def dealer_draw
    return if @dealer.score > MAX_SCORE_DEALER
    return if @turn == MAX_TURNS
  
    card, value = @deck.next_card
    value += A_CARD_BONUS if card.include?('A') && @dealer.score + value < WIN_SCORE
    @dealer.add_card(card, value)

    puts "#{@dealer.name} взял одну карту."
  end

  def player_skip
    puts "#{@player.name} пропускает ход."
  end

  def player_open
    puts "#{@player.name} готов открыть карты."
    open_cards
  end

  def dealer_skip
    puts "#{@dealer.name} пропускает ход."
  end

  def render_information
    player_score
    dealer_score
  
    puts "Возможный выиграш: #{@bank}$."
    puts "Банк игрока: #{@player.bank}$."
    @player.puts_cards
    puts "#{@player.name}: #{@player.score}"
  end

  def last_turn
    return false if @turn < MAX_TURNS
  
    puts "Ход #{@turn}."
    @player.puts_cards
    puts "#{@player.name}: #{@player.score}"

    @dealer.puts_cards
    puts "#{@dealer.name}: #{@dealer.score}"
    
    results
    reset
    
    wipe?
    
    true
  end

  def results    
    if draw?
      draw
    elsif player_won?
      player_won
    elsif dealer_won?
      dealer_won
    end
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

  def both_lost?
    @bank = 0 if @player.lost? && @dealer.lost?
  end

  def player_won
    puts 'Вы победили!'
    @player.increase_bank(@bank)
  end

  def dealer_won
    puts 'Дилер победил!'
    @dealer.increase_bank(@bank)
  end

  def draw
    puts 'Ничья!'
    half_bank = @bank / 2
    @player.increase_bank(half_bank)
    @dealer.increase_bank(half_bank)
  end
  
  def reset
    @turn = 0
    @bank = 0
    @deck = Deck.new
    
    @player.drop if defined? @player
    @dealer.drop if defined? @dealer
  end

  def wipe?
    return unless @player.bank.zero? || @dealer.bank.zero?
    
    raise "Вы проиграли свои деньги!" if @player.bank.zero?
    raise "Диллер проиграл свои деньги!" if @dealer.bank.zero?
  end
  
  def wipe
    @player.reset_bank
    @dealer.reset_bank
  end

  def player_score
    score = 0
    @player.hand.each do |_card, value|
      score += value
    end
    @player.score = score
  end

  def dealer_score
    score = 0
    @dealer.hand.each do |_card, value|
      score += value
    end
    @dealer.score = score
  end

  def welcome
    puts "Добро пожаловать в БлекДжек!"
    puts "А я диллер #{@dealer.name}. Удачи вам, #{@player.name}!"
  end
end
