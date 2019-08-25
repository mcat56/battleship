class Game
attr_reader :game_data

  SHIPS = [
    { name: "Submarine",  length: 2 },
    { name: "Cruiser",    length: 3 },
    { name: "Destroyer",  length: 3 },
    { name: "Battleship", length: 4 },
    { name: "Carrier",    length: 5 }
  ]

  def initialize(players = 1, board_columns = 4, board_rows = 4)
    @game_data     = {}
    @players       = players
    @board_columns = board_columns
    @board_rows    = board_rows
    @area          = @board_columns * @board_rows
    @attempts      = Hash.new(0)
    @turns         = [] 
    # generate_game_data
  end


  def generate_game_data
    if @players == 1
      player = Player.new("Player", true)
      p_board = Board.new(@board_columns, @board_rows)
    else
      player_1 = Player.new("Player_1", true)
      board_1 = Board.new(@board_columns, @board_rows)
      player_2 = Player.new("Player_2", true)
      board_2 = Board.new(@board_columns, @board_rows)
      ships_to_add(@board_columns * @board_rows)
    end

    game_data[:player][:ships] = generate_ships
  end

  def ships_to_add
    ((@area - 16) * 0.04).to_i
  end

  def generate_ships
    ships = []
    total_ships = ships_to_add + 2

    total_ships.times do |index|
      name = SHIPS[index % 5][:name]
      length = SHIPS[index % 5][:length]
      ship = Ship.new(name, length)
      ships << ship
    end
    ships
  end

  # def generate_valid_placement_options
  #   cruiser_coordinate = @computer_board.cells.keys.sample
  #   @horizontal = @computer_board.generate_horizontal_coordinates(cruiser_coordinate)
  #   @vertical = @computer_board.generate_vertical_coordinates(cruiser_coordinate)
#   end

#   def computer_place_cruiser
#     until @horizontal
#     else
#       generate_valid_placement_options
#     end
#   end

#   def computer_place_submarine
#     submarine_coordinate = @computer_board.cells.keys.sample

#      if @computer_board.valid_placement?(@computer.submarine,submarine_coordinates)
#        @computer_board.place(@computer.submarine, submarine_coordinates)
#     else
#       computer_place_submarine
#     end
#   end

#   def user_place_ships
#     puts """
#     I have laid out my ships on the grid.
#     You now need to lay out your two ships.
#     The Cruiser is two units long and the Submarine is three units long.
#     #{@player_board.render}
#     """


#     puts "Enter the squares for the Cruiser (3 spaces):"
#     cruiser_coordinates = gets.chomp
#       until @player_board.valid_placement?(@player.cruiser, cruiser_coordinates) == true
#         puts "Those are invalid coordinates. Please try again:"
#         cruiser_coordinates = gets.chomp
#       end
#     @player_board.place(@player.cruiser, cruiser_coordinates)
#     @board.render(true)
#     puts "Enter the squares for the Submarine (2 spaces):"
#     submarine_coordinates = gets.chomp
#       until @player_board.valid_placement?(@player.submarine,submarine_coordinates) == true
#         puts "Those are invalid coordinates. Please try again:"
#         submarine = gets.chomp
#       end
#       @player_board.place(@player.submarine, submarine_coordinates)
#   end

#   def play
#     @player.ships.any? do |ship|
#       if ship.sunk? == true
#         puts "I won!"
#         welcome
#       end
#     end
#       else
#         @computer.ships.any? do |ship|
#           if ship.sunk? == true
#             puts "You won!"
#             welcome
#             end
#           else
#             turn = Turn.new(@player_board,@computer_board)
#             turn.display_the_boards
#             turn.prompt_user_for_shot
#             turn.user_fires
#             turn.user_result
#             turn.computer_result
#             turn.display_results
#             turn.display_the_boards
#             play
#           end
#       end
#       def display_the_boards
#         puts """
#         =============COMPUTER BOARD=============
#         #{@computer_board.render}
#         ==============PLAYER BOARD==============
#         #{@player_board.render(true)}
#         """
#       end

#       def get_coordinate
#         puts "Enter the coordinate for your shot:"
#         @shot = gets.chomp
#         if valid_fire?(@shot)
#           @shot = shot
#         else
#           "Please enter a valid coordinate:"
#         end
#       end

#       def valid_fire?
#         @player_board.valid_coordinate?(@shot) == true
#       end

#       def user_fires
#         if @attempts[@shot] == 1
#           "You have already fired here. Select a new coordinate."
#         elsif attempts [coordinate] >= 1
#           return
#         else
#           if valid_fire?
#             @computer_board.cells[@shot].fire_upon
#             @attempts[@shot] += 1
#           else
#             "Please enter a valid coordinate"
#           end
#         end
#       end

#       def computer_fire
#         @sample = @player_keys.sample
#         @player_board.cells[@sample].fire_upon
#         @player_keys.delete(@sample)
#       end

#       def user_result
#         if @attempts[@shot] > 1
#             @user_result = "You repeated a previous fire."
#         elsif @computer_board.cells[@shot].render == "M"
#           @user_result = "Your shot on #{@shot} was a miss."
#         elsif @computer_board.cells[@shot].render == "H"
#           @user_result = "Your shot on #{@shot} was a hit!"
#         elsif @computer_board.cells[@shot].render == "X"
#           @user_result = "Your shot on #{@shot} sunk the ship!"
#         end
#       end

#       def computer_result
#         if @player_board.cells[@sample].render == "M"
#           @computer_result = "My shot on #{@shot} was a miss."
#         elsif @player_board.cells[@sample].render == "H"
#           @computer_result = "My shot on #{@shot} was a hit!"
#         elsif @player_board.cells[@sample].render == "X"
#           @computer_result = "My shot on #{@sample} sunk the ship!"
#         end
#       end

#       def display_results
#         puts """
#         #{@user_result}
#         #{@computer_result}
#         """
#       end


end
