class Player
  attr_reader :name, :bank, :score, :hand
  
  I_START_CAPITAL = 100
  
  def initialize(name)
    @bank = I_START_CAPITAL
    @name = name
    @hand = {}
    @score = 0
  end
  
  def add_card(card, value)
    @hand[card] = value
  end
  
  def increase_bank(sum)
    @bank += sum
  end
  
  def decrease_bank(sum)
    @bank -= sum
    @bank = 0 if @bank.negative?
  end
  
  def increase_score(score)
    @score += score
  end
  
  def lost?
    @score > 21 ? true : false
  end
end