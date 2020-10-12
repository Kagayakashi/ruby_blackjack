# frozen_string_literal: true

module Input
  STATES = {
    1 => :player_draw,
    2 => :player_skip,
    3 => :player_open
  }.freeze

  private

  def user_input
    gets.chomp
  end

  def input
    input = user_input.to_i
    raise 'Вы не правильно выбрали ваше действие.' if STATES[input].nil?

    @state = STATES[input]
    dealer_turn
  rescue RuntimeError => e
    puts "Ошибка: #{e.message}"
    retry
  end
end
