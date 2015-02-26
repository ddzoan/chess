class Pawn < Piece
  CAPTURE = { white: [[1, 1], [-1, 1]], black: [[1, -1], [-1, -1]]}
  STEP = { white: [0, 1], black: [0, -1] }

  def image
    "♟"
  end

  def potential_moves
    potential_step_moves(@position) + potential_capture_moves
  end

  def start_row?(pos)
    (self.color == :white && pos[1] == 1) || (self.color == :black && pos[1] == 6)
  end

  def potential_step_moves(pos)
    potential_moves = []
    new_x, new_y = pos
    new_x += STEP[@color][0]
    new_y += STEP[@color][1]
    new_pos = [new_x, new_y]
    if !@board.piece_at(new_pos)
      potential_moves << new_pos
      if start_row?(pos)
        potential_moves += potential_step_moves(new_pos)
      end
    end
    potential_moves
  end

  def potential_capture_moves
    potential_moves = []
    x, y = @position
    CAPTURE[@color].each  do |offset|
      new_x = x + offset[0]
      new_y = y + offset[1]
      new_pos = [new_x, new_y]
      next if !Board.on_board?(new_pos)
      if @board.piece_at(new_pos) && @board.piece_at(new_pos).color != @color
        potential_moves << new_pos
      end
    end

    potential_moves
  end
end
