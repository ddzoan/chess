class Rook < SlidingPiece
  def move_dirs
    ORTH_OFFSET
  end

  def image
    "♜"
  end
end
