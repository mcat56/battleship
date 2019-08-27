require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'
require './lib/turn'
require './lib/game'

def welcome
  "Welcome to BATTLESHIP\nEnter p to play. Enter q to quit"
end

def winner_message(winner)
  if winner == "computer"
    "I won!\n\n\n"
  else
    "You won!\n\n\n"
  end
end


while true
  puts welcome
  choice = gets.chomp
  if choice == "p"
    game = Game.new(["player"])
    puts game.display_boards
    game.place_ships
    winner = false
    while winner == false
      game.take_turn
      winner = game.winner?
    end
    puts winner_message(game.winner)
  elsif choice == "q"
    break
  else
    puts "Invalid input."
  end
end





























      # Enter c to play Classic (10x10 Board)
      # Enter u to play Unique (custom board)
  #   @choice = gets.chomp
  #   if @choice == p
  #     @columns = 4 && @rows = 4
  #   elsif @choice == c
  #     @columns = 10 && @rows = 10
  #   elsif @choice == u
  #     get_game_board_size
  #   elsif @choice == q
  #     return
  #   end
  # end




  #
  # def get_game_board_size
  #   puts "Please enter a length for the boards"
  #   @length = gets.chomp
  #   puts "Please enter a width for the boards"
  #   @width = gets.chomp
  # end
