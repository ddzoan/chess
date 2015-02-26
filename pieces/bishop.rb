class Bishop < SlidingPiece
  def move_dirs
    DIAG_OFFSET
  end

  def image
    "♝"
  end
end
