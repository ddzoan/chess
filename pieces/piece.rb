class Piece
  attr_accessor :position
  attr_reader :color

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def valid_moves
    valid_moves = []
    potential_moves.each do |move|
      valid_moves << move unless move_into_check?(move)
    end

    valid_moves
  end

  def move_into_check?(new_pos)
    new_board = @board.deep_dup
    new_board.move!(@position, new_pos)
    new_board.in_check?(@color)
  end

  def potential_moves
    potential_moves = []
    move_dirs.each do |offset|
      potential_moves += potential_moves_from_offset(offset)
    end

    potential_moves
  end
end
