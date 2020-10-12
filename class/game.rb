# frozen_string_literal: true

class Game
  STATE_WELCOME = 1000
  STATE_WELCOME_HI = 1001
  STATE_PREPARE = 1100
  STATE_FIRST_TURN = 1200
  STATE_INFO = 1300
  STATE_RENDER_PLAYER_TURN = 1400
  STATE_PLAYER_TURN = 1500
  STATE_DEALER_TURN = 1600
  STATE_NEXT_TURN = 1700
  STATE_OPEN = 1800

  STATE_EXIT = 9999

  RENDER_GAME_STATES = {
    STATE_WELCOME => :render_welcome,
    STATE_WELCOME_HI => :render_welcome_hi,
    STATE_INFO => :render_information,
    STATE_RENDER_PLAYER_TURN => :render_player_turn
  }.freeze

  PROCESS_GAME_STATES = {
    STATE_WELCOME => :process_welcome,
    STATE_PLAYER_TURN => :process_player_turn,
    STATE_DEALER_TURN => :process_dealer_turn
  }.freeze

  UPDATE_GAME_STATES = {
    STATE_WELCOME => :update_welcome,
    STATE_PREPARE => :update_prepare,
    STATE_FIRST_TURN => :update_first_draw,
    STATE_NEXT_TURN => :update_next_turn,
    STATE_OPEN => :uppdate_open,
    STATE_EXIT => :exit
  }.freeze

  FIRST_BET = 10
  DEALER_NAME = 'Пётр'
  MAX_SCORE_DEALER = 17
  WIN_SCORE = 21
  MAX_TURNS = 3
  A_CARD_BONUS = 10

  def initialize
    @state = STATE_WELCOME
    run
  end

  private

  def update_prepare
    @turn = 0
    @bank = 0
    @deck = Deck.new
    @player.drop
    @dealer.drop

    @state = STATE_FIRST_TURN
  end

  def update_first_draw
    puts "\nНачало новой партии."

    @turn += 1
    @player.decrease_bank(FIRST_BET)
    @dealer.decrease_bank(FIRST_BET)
    @bank += FIRST_BET + FIRST_BET

    player_draw
    player_draw

    dealer_draw
    dealer_draw

    @state = STATE_NEXT_TURN
  end

  def player_draw
    card, value = @deck.next_card
    value += A_CARD_BONUS if card.include?('A') && @player.score + value < WIN_SCORE
    @player.add_card(card, value)

    puts "#{@player.name} взял одну карту."
  end

  def dealer_draw
    card, value = @deck.next_card
    value += A_CARD_BONUS if card.include?('A') && @dealer.score + value < WIN_SCORE
    @dealer.add_card(card, value)

    puts "#{@dealer.name} взял одну карту."
  end

  def render_player_turn
    @turn += 1

    puts "\nВаши действия:"
    puts '1) Пропустить ход.'
    puts '2) Взять карту.'
    puts '3) Открыть карты.'

    @state = STATE_PLAYER_TURN
  end

  def process_player_turn
    case user_input.to_i
    when 1 then player_skip
    when 2 then player_draw
    when 3 then player_open
    else raise 'Вы не правильно выбрали ваше действие.'
    end

    # В случае открытия, не передавать ход дилеру, открыть все карты
    @state = STATE_DEALER_TURN if @state != STATE_OPEN
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    retry
  end

  def update_open
    @turn += 2

    @state = STATE_NEXT_TURN
  end

  def player_skip
    puts "#{@player.name} пропускает ход."
  end

  def player_open
    puts "#{@player.name} готов открыть карты."
  end

  def process_dealer_turn
    @turn += 1

    dealer_draw if @dealer.score < MAX_SCORE_DEALER
    dealer_skip if @dealer.score > MAX_SCORE_DEALER

    @state = STATE_NEXT_TURN
  end

  def dealer_skip
    puts "#{@dealer.name} пропускает ход."
  end

  def render_information
    puts "Возможный выиграш: #{@bank}$."
    puts "Банк игрока: #{@player.bank}$."
    @player.puts_cards
    puts "#{@player.name}: #{@player.score}"

    @state = STATE_RENDER_PLAYER_TURN
  end

  def update_next_turn
    player_score
    dealer_score

    next_turn if @turn < MAX_TURNS
    last_turn if @turn == MAX_TURNS
  end

  def next_turn
    @state = STATE_INFO
  end

  def last_turn
    puts "Ход #{@turn}."
    @player.puts_cards
    puts "#{@player.name}: #{@player.score}"

    @dealer.puts_cards
    puts "#{@dealer.name}: #{@dealer.score}"

    results
  end

  def results
    if draw?
      draw
    elsif player_won?
      player_won
    elsif dealer_won?
      dealer_won
    end

    @state = wipe?
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

  def wipe?
    return STATE_PREPARE unless @player.bank.zero? || @dealer.bank.zero?

    puts 'У вас закончились деньги! Хотите продолжить играть?' if @player.bank.zero?
    puts 'У дилера закончились деньги! Хотите продолжить играть?' if @dealer.bank.zero?
    puts '1. Да'

    wipe

    return STATE_PREPARE if user_input.to_i == 1

    exit
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

  # Игровой цикл и Основные функции программы. Вывод, Ввод, Обновление.
  def run
    loop do
      render
      process
      update
    end
  end

  def render
    send(RENDER_GAME_STATES[@state]) unless RENDER_GAME_STATES[@state].nil?
  end

  def process
    send(PROCESS_GAME_STATES[@state]) unless PROCESS_GAME_STATES[@state].nil?
  end

  def update
    send(UPDATE_GAME_STATES[@state]) unless UPDATE_GAME_STATES[@state].nil?
  end

  # Функции приветствия. Выполняются только вначале программы
  def render_welcome
    puts 'Добро пожаловать в БлекДжек! Как вас зовут?'
  end

  def render_welcome_hi
    puts "А я диллер #{@dealer.name}. Удачи вам, #{@player.name}!"

    @state = STATE_PREPARE
  end

  def process_welcome
    @player = user_input
  end

  def update_welcome
    @player = Player.new(@player)
    @dealer = Player.new(DEALER_NAME)

    @state = STATE_WELCOME_HI
  end

  # Ввод
  def user_input
    gets.chomp
  end
end
