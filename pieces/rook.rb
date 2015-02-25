class Rook < SlidingPiece
  def move_dirs
    ORTH_OFFSET
  end

  def image
    # [2656].pack('U*')
    "R"
  end
end
