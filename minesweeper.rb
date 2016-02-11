class Board

  def initialize(size=9)
    @size = size
    @grid = Array.new(size) {Array.new(size)}
  end

  def populate

  end

end

class Tile

  attr_accessor :open, :value

  def initialize
    @revealed = false
    @value = nil
  end

  def reveal
    @revealed = true
  end

  def revealed?
    @revealed
  end

end
