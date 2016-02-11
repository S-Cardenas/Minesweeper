require 'byebug'
class Board

  attr_accessor :grid, :size

  def inspect
  end

  def initialize(size=9, bomb_number = 9)
    @size = size
    @grid = Array.new(size) {Array.new(size) {Tile.new(self)}}
    @bomb_number = bomb_number
    self.populate
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
    grid.each do |row|
      row.each do |tile|
        tile.true_value = values.pop
      end
    end
  end

  def render
    grid.each do |row|
      line = []
      row.each do |tile|
        line << tile.value
      end
      p line
    end
    ''
  end

  def render2
    grid.each do |row|
      line = []
      row.each do |tile|
        line << tile.true_value
      end
      p line
    end
    ''
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end
end

class Tile

  attr_accessor :revealed, :true_value, :flag, :display_value

  def initialize(board)
    @revealed = false
    @true_value = nil
    @display_value = '*'
    @flag = false
    @board = board
  end

  def value
    if !@revealed
      @display_value
    elsif @revealed
        debugger
      if neighbor_bomb_count == 0
        @display_value = @true_value
      else
        @display_value = neighbor_bomb_count
      end
    end
    return @display_value
  end

  # def change_display_value
  #   if revealed? && neighbor_bomb_count > 0
  #     @display_value = neighbor_bomb_count
  #   end
  # end

  def reveal
    @revealed = true
  end

  def current_pos
    @board.grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        return [idx1, idx2] if self == tile
      end
    end
  end

  def revealed?
    @revealed
  end

  def flagged
    @flag = true
    @display_value = "F"
  end


  def neighbors
    location = current_pos
    neigh_coor = []
    ((location[0]-1)..(location[0]+1)).each do |i|
      next if i < 0
      next if i >= @board.size
      ((location[1]-1)..(location[1]+1)).each do |j|
        next if j < 0
        next if j >= @board.size
        neigh_coor << [i,j]
      end
    end
    neigh_coor.delete(location)
    neigh_coor
  end

  def neighbor_bomb_count
    bomb_count = 0
    neighbors.each do |neighbor|
      bomb_count += 1 if @board[neighbor].value == "B"
    end
    bomb_count
  end

end

class Player

  def initialize(name = "Borata")
    @name = name
  end

  def prompt_pos
    puts "Please enter the position to explore:(e.g., '2,3')"
    print "> "
  end

  def prompt_action
    puts "Please enter 'reveal or 'flag': ('R' or 'F')"
    print "> "
  end

  def get_pos
    prompt_pos
    parse(STDIN.gets.chomp)
  end

  def parse(string)
    string.split(",").map { |x| Integer(x) }
  end

  def get_action
    prompt_action
    gets.chomp
  end

end

class Minesweeper

  attr_accessor :board

  def initialize(player = Player.new)
    @player = player
    @board = Board.new
  end

  def game_won?
    condition = true
    @board.grid.each do |row|
      row.each do |tile|
        next if tile.value == 'B'
        if !tile.revealed
          return condition = false
        end
      end
    end
    condition
  end

  def take_turn
    @board.render
    @board.render2
    until game_won?
      tile = @player.get_pos
      action = @player.get_action
      if action == 'F'
        @board[tile].flagged
      elsif action == 'R'
        @board[tile].reveal
      end
      @board.render
      @board.render2
    end

  end

end
