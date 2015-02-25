# require 'byebug'
load './piece.rb'

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def self.on_board?(pos)
    x = pos[1]
    y = pos[0]
    x < 8 && x >= 0 && y < 8 && y >= 0
  end

  def piece_at?(pos)
    x = pos[0]
    y = pos[1]
    @board[x][y]
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
    $q = King.new(:white, [4, 2], $b)
    $r = Rook.new(:white, [3, 5], $b)
    $bish = Knight.new(:black, [6, 3], $b)
    $b.board[4][2] = $q
    $b.board[6][3] = $bish
    $b.board[3][5] = $r
end
