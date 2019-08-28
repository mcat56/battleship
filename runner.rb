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
    game.place_computer_ships
    puts """
I have laid out my ships on the grid.
You now need to lay out your #{game.game_data[:player][:ships].length} ships.
The Cruiser is two units long and the Submarine is three units long.
    """
    game.game_data[:player][:ships].each do |ship|
      placed = false
      puts "#{game.game_data[:player][:board].render(true)}"
      puts "The #{ship.name} is #{ship.length} units long.\n"
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"

      until placed == true
        coords = gets.chomp.split
        placed = game.place_player_ships(ship, coords)
        if placed == false
          puts "Those are invalid coordinates. Please try again."
        end
      end
    end

    winner = false
    while winner == false
      fired_on = false
      puts "\n\n#{game.display_boards}"

      until fired_on == true
        puts "Enter the coordinate of your shot:"
        coordinate = gets.chomp
        player_turn = game.take_player_turn(coordinate)
        if player_turn == "already fired"
          puts "That coordinate has alread been fired upon"
        elsif player_turn == true
          fired_on = true
        else
          puts "Those are invalid coordinates. Please try again."
        end
      end

      game.take_computer_turn
      puts "\n\n\n#{game.feedback}\n\n"

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
