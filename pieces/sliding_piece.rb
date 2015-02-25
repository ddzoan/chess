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

      if obstacle = @board.piece_at(new_pos)
        # obstacle = @board.piece_at(new_pos)
        potential_moves << new_pos if obstacle.color != self.color
        break
      else
        potential_moves << new_pos
      end
    end

    potential_moves
  end

end
