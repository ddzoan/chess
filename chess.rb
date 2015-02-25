require 'byebug'
require_relative 'pieces.rb'
require_relative 'board.rb'

class Game
  attr_accessor :player1, :player2, :board
  def initialize(player1, player2)
    @player1, @player2 = player1, player2
    @player1.color = :white
    @player2.color = :black
    @board = Board.new
    @board.initialize_new_game
  end

  def play
    player1_turn = true
    current_player = player1_turn ? @player1 : @player2
    until over?(current_player)
      begin
        @board.display
        start_pos, end_pos = current_player.play_turn
        @board.move(start_pos, end_pos)
      rescue ArgumentError => e
        puts e
        retry
      end
      player1_turn = !player1_turn
      current_player = player1_turn ? @player1 : @player2
    end

    @board.display
    puts "Game Over"
  end

  def over?(current_player)
    @board.checkmate?(current_player.color) || @board.stalemate?(current_player.color)
  end

  def self.test_game
    dan = HumanPlayer.new('dan')
    mike = HumanPlayer.new('mike')
    Game.new(dan,mike)
  end
end



class HumanPlayer
  attr_accessor :color

  COORDINATES = {
    'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5,
    'g' => 6, 'h' => 7, '1' => 0, '2' => 1, '3' => 2, '4' => 3,
    '5' => 4, '6' => 5, '7' => 6, '8' => 7
    }

  def initialize(name)
    @name = name
    @color = nil
  end

  def play_turn
    puts "Choose piece to move #{@name}: "
    start_pos = gets.chomp
    puts "Choose destination: "
    end_pos = gets.chomp
    start_pos = notation_to_coord(start_pos)
    end_pos = notation_to_coord(end_pos)
    [start_pos, end_pos]
  end

  def notation_to_coord(notation)
    notation.split('').map { |char| COORDINATES[char] }
  end
end

if __FILE__ != $PROGRAM_NAME
  # load 'chess.rb'
  $b = Board.new

  def checkmate
    $b.initialize_new_game
    $b.move([5, 1], [5, 2])
    $b.move([4, 6], [4, 5])
    $b.move([6, 1], [6, 3])
    $b.move([3, 7], [7, 3])
  end

  def checkmate2
    $b.initialize_new_game
    $b.move([4,1],[4,3])
    $b.move([4,6],[4,4])
    $b.move([5,0],[2,3])
    $b.move([0,6],[0,5])
    $b.move([3,0],[5,2])
    $b.move([0,5],[0,4])
    $b.move([5,2],[5,6])
  end

  def stalemate
    $b.place_piece(King.new(:white,[0,0],$b),[0,0])
    $b.place_piece(King.new(:black,[7,0],$b),[7,0])
    $b.place_piece(Queen.new(:black,[1,2],$b),[1,2])
  end

  def moves(pos)
    piece = $b.piece_at(pos)
    puts "#{piece.class} has potential moves #{piece.potential_moves}"
  end
end
