class Bishop < SlidingPiece
  def move_dirs
    DIAG_OFFSET
  end

  def image
    # [2657].pack('U*')
    "B"
  end
end
