class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def valid_moves
    potential_moves
  end

  def potential_moves
    potential_moves = []
    move_dirs.each do |offset|
      potential_moves += potential_moves_from_offset(offset)
    end

    potential_moves
  end
end
