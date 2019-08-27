require 'pry'
class Game
attr_reader :game_data, :turns, :winner

  SHIPS = [
    { name: "Submarine",  length: 2 },
    { name: "Cruiser",    length: 3 },
    { name: "Destroyer",  length: 3 },
    { name: "Battleship", length: 4 },
    { name: "Carrier",    length: 5 }
  ]

  def initialize(player_names, board_columns = 4, board_rows = 4)
    @game_data     = {}
    @player_names  = player_names
    @board_columns = board_columns
    @board_rows    = board_rows
    @area          = @board_columns * @board_rows
    @attempts      = Hash.new(0)
    @turns         = []
    @generated_ship_coordinates = nil
    @winner = ""
    generate_game_data

    @computer_shot_choices = @game_data[:player][:board].cells.keys
  end

  def generate_game_data
    players = generate_players
    players.each do |player|
      @game_data[player.name.to_sym] = {}
      @game_data[player.name.to_sym][:player] = player
      @game_data[player.name.to_sym][:ships] = generate_ships
      @game_data[player.name.to_sym][:board] = Board.new(@board_columns, @board_rows)
    end
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

  def generate_players
    players = []
    if @player_names.length == 1
      new_player = Player.new(@player_names.first, true)
      computer = Player.new
      players.push(new_player, computer)
    else
      @player_names.each do |player|
        new_player = Player.new(player, true)
        players.push(new_player)
      end
    end
    players
  end

  def display_boards
    "=============COMPUTER BOARD=============\n#{@game_data[:computer][:board].render}==============PLAYER BOARD==============\n#{@game_data[:player][:board].render(true)}"""
  end


  def place_ships
    @game_data[:computer][:ships].each do |ship|
      placed = false
      until placed == true
        starting_coordinate = @game_data[:computer][:board].cells.keys.sample
        coordinate_options = @game_data[:computer][:board].generate_valid_coordinates([starting_coordinate], ship.length)

        coordinate_options.keep_if do |coordinates|
          coordinates.length > 0
        end

        coordinates = coordinate_options.sample
        if coordinate_options.length > 0 && @game_data[:computer][:board].valid_placement?(ship, coordinates)
          @game_data[:computer][:board].place(ship, coordinates)
          placed = true
        end
      end
    end
    require 'pry'; binding.pry
    puts """
    I have laid out my ships on the grid.
    You now need to lay out your #{@game_data[:player][:ships].length} ships.
    The Cruiser is two units long and the Submarine is three units long.
    """

    @game_data[:player][:ships].each do |ship|
      placed = false
      puts "#{@game_data[:player][:board].render}"
      puts "The #{ship.name} is #{ship.length} units long.\n"
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.split
      if @game_data[:player][:board].valid_placement?(ship, coordinates)
        @game_data[:player][:board].place(ship, coordinates)
      else
        until placed == true
          if @game_data[:player][:board].valid_placement?(ship, coordinates)
            @game_data[:player][:board].place(ship, coordinates)
            placed = true
          else
            puts "Those are invalid coordinates. Please try again."
            coordinates = gets.chomp.split
          end
        end
      end
    end
  end

  def take_turn
    puts display_boards
    puts "Enter the coordinate of your shot:"
    fired_on = false
    coordinate = gets.chomp

    until fired_on == true
      if @game_data[:computer][:board].valid_coordinate?(coordinate)
        if @game_data[:computer][:board].cells[coordinate].fired_upon?
          puts "That coordinate has alread been fired upon"
          puts "Enter the coordinate of your shot:"
          coordinate = gets.chomp
        else
          @game_data[:computer][:board].cells[coordinate].fire_upon
          @turns.add_turn(Turn.new(coordiante, @game_data[:player], @game_data[:computer]))
          fired_on = true
        end
      else
        puts "Those are invalid coordinates. Please try again."
        puts "Enter the coordinate of your shot:"
        coordinate = gets.chomp
      end
    end

    coordinate = @computer_shot_choices.sample
    @game_data[:player][:board].cells[coordiante].fire_upon
    @turns.add_turn(Turn.new(coordiante, @game_data[:computer], @game_data[:player]))
    @computer_shot_choices.delete(coordiante)

    feedback
  end

  def feedback
    result = @turns[-2].defender_data[:board].cells[@turns[-2].coordinate].render
    feedback_string = ""
    if result == "M"
      feedback_string << "Your shot on #{@turns[-2].coordinate} was a miss.\n"
    elsif result == "H"
      feedback_string << "Your shot on #{@turns[-2].coordinate} was a hit!\n"
    elsif result == "X"
      ship_name = @turns[-2].defender_data[:board].cells[@turns[-2].coordinate].ship.name
      feedback_string << "Your shot on #{@turns[-2].coordinate} sunk my #{ship_name}!\n"
    end

    result = @turns[-1].defender_data[:board].cells[@turns[-1].coordinate].render
    if result == "M"
      feedback_string << "My shot on #{@turns[-1].coordinate} was a miss."
    elsif result == "H"
      feedback_string << "My shot on #{@turns[-1].coordinate} was a hit!"
    elsif result == "X"
      ship_name = @turns[-1].defender_data[:board].cells[@turns[-1].coordinate].ship.name
      feedback_string << "My shot on #{@turns[-1].coordinate} sunk your #{ship_name}!"
    end
    feedback_string
  end

  def add_turn(turn)
    @turns.push(turn)
  end

  def check_for_winner
    if @game_data[:computer][:ships].all? { |ship| ship.sunk? }
      @winner << "#{@game_data[:player][:player].name}"
    elsif @game_data[:player][:ships].all? { |ship| ship.sunk? }
      @winner << "#{@game_data[:computer][:player].name}"
    end
  end

  def winner?
    @winner != ""
  end







  # def generate_valid_computer_placement(ship)
  #   start = @game_data[:computer][:board].cells.keys.sample
  #   coordinate_options = @game_data[:computer][:board].generate_valid_coordinates([start],ship.length)
  #   found = coordinate_options.find do |coordinates|
  #      @game_data[:computer][:board].valid_placement?(ship,coordinates)
  #    end
  #    found
  # # end
  #
  # def take_turn
  #     @game_data.each do |player,hash|
  #       if hash[player].human?
  #         keys = hash[player][:board].cells.keys
  #         shot = hash[player][:board].cells.keys.sample
  #         hash[player][:board].cells[shot].fire_upon
  #         @turns << Turn.new(shot,"computer", @players[0])
  #         keys.delete(shot)
  #       else
  #         puts "Enter the coordinate for your shot:"
  #         @shot = gets.chomp
  #           if @attempts[@shot] == 1
  #             "You have already fired here. Select a new coordinate."
  #           elsif @attempts[@shot] > 1
  #             return
  #           elsif @game_data[:computer][:board].valid_coordinate?(@shot) == true
  #             @game_data[:computer][:board].cells[@shot].fire_upon
  #             @turns << Turn.new(@shot,players[0], "computer")
  #             @attempts[@shot] += 1
  #           else
  #             #check again for repeated coordiantes
  #             until @game_data[:computer][:board].valid_coordinate?(@shot) == true
  #               puts "Please enter a valid coordinate:"
  #               @shot = gets.chomp
  #             end
  #             @game_data[:computer][:board].cells[@shot].fire_upon
  #             @attempts[@shot] += 1
  #             @turns << Turn.new(@shot,players[0], "computer")
  #           end
  #         end
  #       end
  #   end

    # def take_turn_multi_player
    #   players = []
    #   @game_data.each do |player,hash|
    #     players << hash[:player]
    #   end
    #     attacker = players.sample
    #       if players.length == 2
    #         players.delete(attacker)
    #         defender = players.sample
    #       else
    #         puts "#{attacker.name} enter the player you wish to attack"
    #         defender = gets.chomp
    #         puts "#{attacker.name} enter the coordinate for your shot:"
    #         @shot = gets.chomp
    #           if @attempts[@shot] == 1
    #             "You have already fired here. Select a new coordinate."
    #           elsif @attempts[@shot] > 1
    #             return
    #           elsif @game_data[key].valid_coordinate?(@shot) == true
    #             @game_data[:computer][:board].cells[@shot].fire_upon
    #             @attempts[@shot] += 1
    #           else
    #             until @game_data[:computer][:board].valid_coordinate?(@shot) == true
    #               puts "Please enter a valid coordinate:"
    #               @shot = gets.chomp
    #             end
    #             @game_data[:computer][:board].cells[@shot].fire_upon
    #             @attempts[@shot] += 1
    #           end
    #         end
    #   end





end
