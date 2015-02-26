require 'colorize'

class Board
  attr_accessor :board

  BG = [:green, :red]
  PIECE_COLOR = [:white, :black]

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
    x, y = pos
    x < 8 && x >= 0 && y < 8 && y >= 0
  end

  def piece_at(pos)
    x, y = pos
    @board[x][y]
  end

  def move(start, end_pos)
    if piece_at(start)
      piece = piece_at(start)
      raise ChessError.new "Can't move in to check!" if piece.move_into_check?(end_pos)
      if piece.valid_moves.include?(end_pos)
        move!(start, end_pos)
      else
        raise ChessError.new "Invalid end position!"
      end
    else
      raise ChessError.new "Invalid starting position!"
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
    populate_pieces
  end

  def populate_pawns
    8.times do |x|
      @board[x][1] = Pawn.new(:white, [x, 1], self)
      @board[x][6] = Pawn.new(:black, [x, 6], self)
    end
  end

  PIECE_ORDER = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  def populate_pieces
    8.times do |x|
      @board[x][0] = PIECE_ORDER[x].new(:white, [x, 0], self)
      @board[x][7] = PIECE_ORDER[x].new(:black, [x, 7], self)
    end
  end

  def render
    rendering = ''
    @board.transpose.reverse.each_with_index do |x, i|
      rendering += (8 - i).to_s
      x.each_with_index do |y, j|
        if y
          white_piece = y.color == :white
          rendering += ((y.image + ' ').colorize( :background => (i + j).even? ? BG[0] : BG[1] ).colorize(white_piece ? PIECE_COLOR[0] : PIECE_COLOR[1]))
        else
          rendering += "  ".colorize( :background => (i + j).even? ? BG[0] : BG[1] )
        end
      end
      rendering += "\n"
    end
    rendering += " "
    ('a'..'h').to_a.each do |letter|
      rendering += letter + ' '
    end
    rendering
  end

  def display
    puts render
  end
end
