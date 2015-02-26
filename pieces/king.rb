class King < SteppingPiece
  KING_OFFSET = [[1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1], [1,-1]]

  def move_dirs
    KING_OFFSET
  end

  def image
    "♚"
  end
end
