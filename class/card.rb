# frozen_string_literal: true

class Card
  attr_reader :name, :value
  def initialize(name, value)
    @name = name
    @value = value
  end

  def ace?
    @name.include?('A')
  end

  def ace_value(first)
    @value = 1 if first
  end
end
