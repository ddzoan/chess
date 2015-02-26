require 'byebug'
require_relative 'pieces.rb'
require_relative 'board.rb'

class ChessError < ArgumentError
end

class Game
  attr_accessor :players, :board

  COORDINATES = {
    'a' => 0,
    'b' => 1,
    'c' => 2,
    'd' => 3,
    'e' => 4,
    'f' => 5,
    'g' => 6,
    'h' => 7,

    '1' => 0,
    '2' => 1,
    '3' => 2,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 7
    }

  def initialize(player1, player2)
    player1.color = :white
    player2.color = :black
    @players = [player1, player2]
    @board = Board.new
    @board.initialize_new_game
  end

  def play
    error = nil
    current_player = @players.first

    until over?(current_player)
      begin
        system('clear')
        @board.display
        puts "\n#{error.to_s.colorize(:red)}" if error
        puts "You are in check!".colorize(:red) if @board.in_check?(current_player.color)
        start_pos, end_pos = play_turn(current_player)
        raise ChessError.new "That is not your piece!" if @board.piece_at(start_pos).color != current_player.color
        @board.move(start_pos, end_pos)
      rescue ArgumentError => error
        retry
      end
      error = nil
      @players.rotate!
      current_player = @players.first
    end

    end_game_message
  end

  def play_turn(current_player)
    move_start = current_player.move_start
    raise ChessError.new "Invalid start move format" unless move_start =~ /\A[a-h][1-8]\z/
    move_start = notation_to_coord(move_start)
    move_end = current_player.move_end
    raise ChessError.new "Invalid end move format" unless move_end =~ /\A[a-h][1-8]\z/
    move_end = notation_to_coord(move_end)

    [move_start, move_end]
  end

  def notation_to_coord(notation)
    notation.split('').map { |char| COORDINATES[char] }
  end

  def over?(current_player)
    @board.checkmate?(current_player.color) || @board.stalemate?(current_player.color)
  end

  def self.test_game
    player1 = HumanPlayer.new('# 1')
    player2 = HumanPlayer.new('player 2')
    Game.new(player1,player2)
  end

  def end_game_message
    system("clear")
    @board.display
    current_player = @players.first
    if @board.checkmate?(current_player.color)
      puts "#{current_player.name} sucks at life but mostly chess."
    else
      puts "STALEMATE BITCHES!!!".colorize(:red)
    end
  end

  def self.stalemate_test # move queen to b3 to stalemate
    player1 = HumanPlayer.new('should lose')
    player2 = HumanPlayer.new('mr move-to-b3-to-stalemate')
    g = Game.new(player1, player2)
    # @players = [player2, player1]
    g.board = Board.new
    g.board.place_piece(King.new(:white,[0,0],g.board),[0,0])
    g.board.place_piece(King.new(:black,[7,0],g.board),[7,0])
    g.board.place_piece(Queen.new(:black,[1,3],g.board),[1,3])
    g.players.rotate!
    g
  end
end

class HumanPlayer
  attr_accessor :color


  def initialize(name)
    @name = name
    @color = nil
  end

  def move_start
    puts "Choose piece to move #{@name}: "
    start_pos = gets.chomp
  end

  def move_end
    puts "Choose destination: "
    end_pos = gets.chomp
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
