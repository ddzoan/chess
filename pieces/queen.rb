class Queen < SlidingPiece
  def move_dirs
    ORTH_OFFSET + DIAG_OFFSET
  end

  def image
    # [2655].pack('U*')
    "Q"
  end
end
