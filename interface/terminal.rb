# frozen_string_literal: true

require_relative '../class/game'

require_relative 'e_wipe.rb'

class TInterface
  DEALER_NAME = 'Пётр'

  def initialize
    puts 'Здравствуйте! Как вас зовут?'
    @game = Game.new(gets.chomp, DEALER_NAME, 100)

    puts 'Добро пожаловать в БлекДжек!'
    puts "А я диллер #{@game.dealer.name}. Удачи вам, #{@game.player.name}!"

    start_game
  end

  def start_game
    @game.hard_reset
    loop do
      wipe?
      # Round start
      puts 'Новый раунд'
      @game.reset
      first_draw
      puts "Банк игрока: #{@game.player.bank}$"
      player_hand
      ask_action
      player_action
      results
    end
  rescue Wipe
    puts 'Вы хотите продолжить играть? (Напишите - да, если согласны.)'
    exit if gets.chomp != 'да'
    retry
  end

  def results
    dealer_hand
    puts "Выиграш #{@game.bank}$"
    winner = @game.winner
    puts "Победил #{winner.name}!" unless winner.nil?
    winner&.increase_bank(bet)
    draw if winner.nil?
  end

  def draw
    puts 'Ничья!'
    @game.player.increase_bank(bet)
    @game.dealer.increase_bank(bet)
  end

  def bet(bet = 10)
    bet
  end

  def player_hand
    puts 'Карты игрока:'
    @game.player.hand.each { |c| print "#{c.name} " }
    puts "(#{@game.player.score})"
  end

  def dealer_hand
    puts 'Карты диллера:'
    @game.dealer.hand.each { |c| print "#{c.name} " }
    puts "(#{@game.dealer.score})"
  end

  def first_draw
    @game.player.decrease_bank(bet)
    puts "#{@game.player.name} сделал ставку #{bet}$."
    @game.dealer.decrease_bank(bet)
    puts "#{@game.dealer.name} сделал ставку #{bet}$."

    @game.increase_bank(bet)
    @game.increase_bank(bet)

    @game.player_draw
    puts "#{@game.player.name} взял карту."
    @game.player_draw
    puts "#{@game.player.name} взял карту."

    @game.dealer_draw
    puts "#{@game.dealer.name} взял карту."
    @game.dealer_draw
    puts "#{@game.dealer.name} взял карту."
  end

  def wipe?
    raise Wipe, 'Вы проиграли свои деньги!' if @game.player.bank.zero?
    raise Wipe, 'Диллер проиграл свои деньги!' if @game.dealer.bank.zero?
  end

  def ask_action
    puts "\nВаши действия:"
    puts '1) Пропустить ход.'
    puts '2) Взять карту.'
    puts '3) Открыть карты.'
  end

  def player_action
    case gets.chomp
    when '1'    then player_skip
    when '2'    then player_draw
    when '3'    then player_open
    when 'exit' then exit
    else raise 'Выбор неверный!'
    end
  rescue RuntimeError => e
    puts "Ошибка ввода: #{e.message}"
    retry
  end

  def dealer_draw
    is_draw = @game.dealer_draw
    puts "#{@game.dealer.name} взял карту." if is_draw
  end

  def player_draw
    @game.player_draw
    puts "#{@game.player.name} взял карту."
    dealer_draw
    player_hand
  end

  def player_skip
    puts "#{@game.player.name} пропустил ход."
    dealer_draw
  end

  def player_open
    puts "#{@game.player.name} открыл карты!"
  end
end
