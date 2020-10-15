require_relative '../class/game'

class TInterface

  DEALER_NAME = "Пётр"

  def initialize
    @game = Game.new
    welcome
    @game.welcome
    start_game
  end
  
  def start_game
    loop do
      next if last_turn?
      next_turn
      info
      ask_action
      player_action
    end
  end
  
  def player_action
    case gets.chomp
    when "1"    then action_skip
    when "2"    then action_draw
    when "3"    then action_open
    when "exit" then exit
    else raise 'Вы не правильно выбрали ваше действие.'
    end

  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    retry
  end
  
  def ask_action
    puts "\nВаши действия:"
    puts '1) Пропустить ход.'
    puts '2) Взять карту.'
    puts '3) Открыть карты.'
  end
  
  def action_skip
    @game.player_skip
  end
  
  def action_draw
    @game.player_draw
  end
  
  def action_open
    @game.player_open
  end
  
  def next_turn
    @game.next_turn
  end
  
  def info
    @game.render_information
  end
  
  def last_turn?
    @game.last_turn
  rescue RuntimeError => e
    @game.wipe
    puts "Игра окончена: #{e.message}"
    puts "Продолжить? (да/нет)"
    exit if gets.chomp.downcase == "нет"
  end
  
  def welcome
    puts "Здравствуйте! Как вас зовут?"
    @game.create_player(gets.chomp)
    @game.create_dealer(DEALER_NAME)
  end
end