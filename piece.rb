class Piece
  attr_reader :color

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end

  def valid_moves
    potential_moves
  end
end

class Pawn < Piece
end

class SteppingPiece < Piece
  def potential_moves
    potential_moves = []
    MOVE_OFFSET.each do |offset|
      # some logic
    end
    potential_moves
  end
end

class Knight < SteppingPiece
  MOVE_OFFSET = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
end

class King < SteppingPiece
  MOVE_OFFSET = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]
  def image
    [2654].pack('U*')
  end
end

class SlidingPiece < Piece
  ORTH_OFFSET = [[0,1],[0,-1],[1,0],[-1,0]]
  DIAG_OFFSET = [[1,1],[1,-1],[-1,1],[-1,-1]]


  def potential_moves_from_offset(offset)
    potential_moves = []
    row, col = @position
    while true
      row += offset[0]
      col += offset[1]
      new_pos = [row, col]
      break unless Board.on_board?(new_pos)

      if obstacle = @board.piece_at?(new_pos)
        # obstacle = @board.piece_at(new_pos)
        potential_moves << new_pos if obstacle.color != self.color
        break
      else
        potential_moves << new_pos
      end
    end

    potential_moves
  end

  def potential_moves
    potential_moves = []
    move_dirs.each do |offset|
      potential_moves += potential_moves_from_offset(offset)
    end
    potential_moves
  end

  def legal_move?()
    # logic to decide if move is valid
  end


end

class Rook < SlidingPiece
  def move_dirs
    SlidingPiece::ORTH_OFFSET
  end

  def image
    # [2656].pack('U*')
    "R"
  end
end

class Bishop < SlidingPiece
  def move_dirs
    SlidingPiece::DIAG_OFFSET
  end

  def image
    # [2657].pack('U*')
    "B"
  end
end

class Queen < SlidingPiece
  def move_dirs
    SlidingPiece::ORTH_OFFSET + SlidingPiece::DIAG_OFFSET
  end

  def image
    # [2655].pack('U*')
    "Q"
  end
end
