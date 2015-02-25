class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def initialize_new_game
    populate_board
  end

  def deep_dup
    new_board = Board.new
    @board.flatten.compact.each do |piece|
      color = piece.color
      new_pos = piece.position.dup
      new_board.place_piece(piece.class.new(color, new_pos, new_board), new_pos)
    end
    new_board
  end

  def in_check?(color)
    king_pos = king(color).position
    other_color_pieces(color).each do |piece|
      return true if piece.potential_moves.include?(king_pos)
    end

    false
  end

  def all_pieces
    @board.flatten.compact
  end

  def other_color_pieces(color)
    all_pieces.select { |piece| piece.color != color }
  end

  def same_color_pieces(color)
    all_pieces.select { |piece| piece.color == color }
  end

  def king(color)
    king = same_color_pieces(color).find { |piece| piece.color == color && piece.is_a?(King) }
    raise "King not found" unless king
    king
  end

  def any_valid_moves?(color)
    same_color_pieces(color).each do |piece|
      return true unless piece.valid_moves.empty?
    end
    false
  end

  def checkmate?(color)
    in_check?(color) && !any_valid_moves?(color)
  end

  def stalemate?(color)
    !in_check?(color) && !any_valid_moves?(color)
  end

  def self.on_board?(pos)
    # x, y = pos
    x = pos[0]
    y = pos[1]
    x < 8 && x >= 0 && y < 8 && y >= 0
  end

  def piece_at(pos)
    x = pos[0]
    y = pos[1]
    @board[x][y]
  end

  def move(start, end_pos)
    if piece_at(start)
      piece = piece_at(start)
      raise ArgumentError.new "Can't move in to check!" if piece.move_into_check?(end_pos)
      if piece.valid_moves.include?(end_pos)
        move!(start, end_pos)
      else
        raise ArgumentError.new "Invalid end position!"
      end
    else
      raise ArgumentError.new "Invalid starting position!"
    end
  end

  def move!(start, end_pos)
    piece = piece_at(start)
    place_piece(piece,end_pos)
    piece.position = end_pos
    remove_piece(start)
  end

  def remove_piece(pos)
    x, y = pos
    @board[x][y] = nil
  end

  def place_piece(piece, pos)
    x, y = pos
    @board[x][y] = piece
  end

  def populate_board
    populate_pawns
    populate_rooks
    populate_knights
    populate_bishops
    populate_kings
    populate_queens
  end

  def populate_pawns
    8.times do |x|
      @board[x][1] = Pawn.new(:white, [x, 1], self)
      @board[x][6] = Pawn.new(:black, [x, 6], self)
    end
  end

  def populate_bishops
    @board[2][0] = Bishop.new(:white, [2,0], self)
    @board[5][0] = Bishop.new(:white, [5,0], self)
    @board[2][7] = Bishop.new(:black, [2,7], self)
    @board[5][7] = Bishop.new(:black, [5,7], self)
  end

  def populate_knights
    @board[1][0] = Knight.new(:white, [1,0], self)
    @board[6][0] = Knight.new(:white, [6,0], self)
    @board[1][7] = Knight.new(:black, [1,7], self)
    @board[6][7] = Knight.new(:black, [6,7], self)
  end

  def populate_rooks
    @board[0][0] = Rook.new(:white, [0,0], self)
    @board[7][0] = Rook.new(:white, [7,0], self)
    @board[0][7] = Rook.new(:black, [0,7], self)
    @board[7][7] = Rook.new(:black, [7,7], self)
  end

  def populate_kings
    @board[4][0] = King.new(:white, [4,0], self)
    @board[4][7] = King.new(:black, [4,7], self)
  end

  def populate_queens
    @board[3][0] = Queen.new(:white, [3,0], self)
    @board[3][7] = Queen.new(:black, [3,7], self)
  end

  def render
    rendering = ''
    @board.transpose.reverse.each_with_index do |x, i|
      rendering += (8 - i).to_s + "| "
      x.each do |y|
        rendering += (y ? y.image : '-') + ' '
      end
      rendering += "\n"
    end
    rendering += "_" * 18 + "\n"
    rendering += ' | '
    ('a'..'h').to_a.each do |letter|
      rendering += letter + ' '
    end
    rendering
  end

  def display
    puts render
  end
end
