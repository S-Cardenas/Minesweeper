require 'byebug'
class Board

  def inspect
  end

  def initialize(size=9, bomb_number = 9)
    @size = size
    @grid = Array.new(size) {Array.new(size) {Tile.new}}
    @bomb_number = bomb_number
  end

  def populate
    values = Array.new(@size**2)
    values.each_with_index do |ele, idx|
      if idx < @bomb_number
        values[idx] = "B"
      else
        values[idx] = " "
      end
    end
    values = values.shuffle
    @grid.each do |row|
      row.each do |tile|
        tile.value = values.pop
      end
    end
  end

  def render
    @grid.each do |row|
      line = []
      row.each do |tile|
        line << tile.value
      end
      p line
    end
    ''
  end

  def is_a_bomb?
  end

  def check_adjacent(pos)
  end
end

class Tile

  attr_accessor :revealed, :value

  def initialize
    @revealed = false
    @value = nil
    @flag = false
  end

  def reveal
    @revealed = true
  end

  def revealed?
    @revealed
  end

  def flagged
    @flag = true
  end

  def value
    if @revealed
      @value
    elsif @flag
      'F'
    elsif @value = ' '
      '*'
    end
  end

end
