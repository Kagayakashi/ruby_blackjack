class Game

  DEALER_NAME = "Диллер Пётр"

  def initialize
    welcome
    run
  end
  
  private
  
  def user_input
    gets.chomp
  end
  
  def welcome
    puts "Добро пожаловать в БлекДжек! Как вас зовут?"
    
    @player = Player.new(user_input)
    @dealer = Player.new(DEALER_NAME)
    @deck = Deck.new
    
    puts "Здравствуйте, #{@player.name}! А меня зовут #{@dealer.name}."
  end
  
  def run
    @turn = 0
    loop do      
      process
      update
      render
      break
    end
  end
  
  def process
    return if @turn.zero?
    
    
  end
  
  def update    
    first_draw if @turn.zero?
    draw unless @turn.zero?
    
    @turn += 1
  end
  
  def render
    lose_game if @player.lost?
    win_game if @dealer.lost?
    
    hands_info
  end
  
  def first_draw
    draw
    draw
  end
  
  def draw
    card, value = @deck.next_card
    @player.add_card(card, value)
    
    card, value = @deck.next_card
    @dealer.add_card(card, value)
  end
  
  def hands_info
    puts "Карты игрока #{@player.hand}."
    puts "Карты Дилера #{@dealer.hand}."
    puts "В колоде осталось #{@deck.cards_left} карт."
  end
  
  def win_game
    puts "Победа!"
    exit
  end
  
  def lose_game
    puts "Поражение!"
    exit
  end
end