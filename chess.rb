require 'byebug'
require_relative 'pieces.rb'

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
      x, y = piece.position
      new_board[x][y] = piece.class.new(color, [x, y], new_board)
    end
    new_board
  end

  def self.on_board?(pos)
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
      if piece.potential_moves.include?(end_pos)
        place_piece(piece,end_pos)
        piece.position = end_pos
        remove_piece(start)
      else
        raise ArgumentError.new "Invalid end position!"
      end
    else
      raise ArgumentError.new "Invalid starting position!"
    end
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
      rendering += (7 - i).to_s + "| "
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


if __FILE__ != $PROGRAM_NAME
  # load 'chess.rb'
  $b = Board.new
  $p1 = $b.piece_at([0,1])
  def moves(pos)
    piece = $b.piece_at(pos)
    puts "#{piece.class} has potential moves #{piece.potential_moves}"
  end
end
