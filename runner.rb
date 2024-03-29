require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'
require './lib/turn'
require './lib/game'

def welcome
  "Welcome to BATTLESHIP\nEnter p to play\nEnter q to quit."
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
    puts "Do you want to customize your board? (Yes or No)"
    custom = gets.chomp.downcase
    if custom == "no"
      puts "Would you like to customize your ships? (Yes or No)"
      custom = gets.chomp.downcase
      if custom == "no"
        game = Game.new(["player"], 4, 4, false)
      end
    else
      puts "Please enter a number of columns for the boards (minimum of 4)"
      columns = gets.chomp.to_i
      too_small = true
      until too_small == false
        if columns < 4
          puts "That is too small, please try again."
          columns = gets.chomp.to_i
        else
          too_small = false
        end
      end
      puts "Please enter a number of rows for the boards (minimum of 4)"
      rows = gets.chomp.to_i
      too_small = true
      until too_small == false
        if rows < 4
          puts "That is too small, please try again."
          rows = gets.chomp.to_i
        else
          too_small = false
        end
      end
      ship_count = (((columns * rows) - 16) * 0.04).to_i + 2
      puts "Would you like to customize your ships? (Yes or No)"
      custom = gets.chomp.downcase
      if custom == "no"
        game = Game.new(["player"], columns, rows, false)
      else
        ship_count = ((rows * columns - 16) * 0.04) + 2
        ship_data  = {}
        ship_count = (1..ship_count).to_a
        ship_count[-1].times do
          puts "Please enter a name for ship number #{ship_count[0]}"
          name = gets.chomp.capitalize
          puts "Please enter a length for ship number #{ship_count[0]} (length must be between 2-5)"
          input  = false
          length = gets.chomp
          until input == true
            if ["2","3","4","5"].include?(length) == true
              ship_data[name] = length.to_i
              ship_count.shift
              input = true
            else
              puts "Please enter a correct length"
              length = gets.chomp
            end
          end
        end
        game = Game.new(["player"], columns, rows, true, ship_data)
      end
    end

    game.place_computer_ships
    puts """
I have laid out my ships on the grid.
You now need to lay out your #{game.game_data[:player][:ships].length} ships.
"""
      game.game_data[:player][:ships].each do |ship|
        placed = false
        puts "#{game.game_data[:player][:board].render(true)}"
        puts "The #{ship.name} is #{ship.length} units long.\n"
        puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"

        until placed == true
          coords = gets.chomp.upcase.split
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
        coordinate = gets.chomp.upcase
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
