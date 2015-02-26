class Knight < SteppingPiece
  KNIGHT_OFFSET = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]

  def move_dirs
    KNIGHT_OFFSET
  end

  def image
    "♞"
  end
end
