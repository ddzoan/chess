class SteppingPiece < Piece
  def potential_moves
    potential_moves = []
    move_dirs.each do |offset|
      potential_moves += potential_moves_from_offset(offset)
    end
    potential_moves
  end

  def potential_moves_from_offset(offset)
    potential_moves = []
    row, col = @position

    row += offset[0]
    col += offset[1]
    new_pos = [row, col]
    return [] unless Board.on_board?(new_pos)

    if obstacle = @board.piece_at?(new_pos)
      # obstacle = @board.piece_at(new_pos)
      return [new_pos] if obstacle.color != self.color
    else
      return [new_pos]
    end
    []
  end
end

class Knight < SteppingPiece
  KNIGHT_OFFSET = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]

  def move_dirs
    KNIGHT_OFFSET
  end

  def image
    'K'
  end
end

class King < SteppingPiece
  KING_OFFSET = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]

  def move_dirs
    KING_OFFSET
  end

  def image
    # [2654].pack('U*')
    '+'
  end
end
