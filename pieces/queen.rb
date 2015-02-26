class Queen < SlidingPiece
  def move_dirs
    ORTH_OFFSET + DIAG_OFFSET
  end

  def image
    "♛"
  end
end
