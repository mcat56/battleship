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

  def initialize(player_names, board_columns = 4, board_rows = 4, custom_ships = false, ship_data = {}, smart = false)
    @game_data     = {}
    @smart = smart
    @custom_ships = custom_ships
    @ship_data = ship_data
    @player_names  = player_names
    @board_columns = board_columns
    @board_rows    = board_rows
    @area          = @board_columns * @board_rows
    @attempts      = Hash.new(0)
    @direction = nil
    @turns         = []
    @winner = ""
    @players = generate_players
    generate_game_data

    @computer_shot_choices = @game_data[:player][:board].cells.keys
  end

  def generate_game_data
    @players.each do |player|
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
    total_ships = ships_to_add + 2
    ships = []
    if @custom_ships == false
      total_ships.times do |index|
          name = SHIPS[index % 5][:name]
          length = SHIPS[index % 5][:length]
          ship = Ship.new(name, length)
          ships << ship
        end
    else
      @ship_data.each do |name,length|
        name = Ship.new(name,length.to_i)
        ships << name
        end
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


  def place_computer_ships
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
  end

  def place_player_ships(ship,coordinates)
    if @game_data[:player][:board].valid_placement?(ship, coordinates)
      @game_data[:player][:board].place(ship, coordinates)
      return true
    end
    return false
  end

  def take_player_turn(coordinate)
    if @game_data[:computer][:board].valid_coordinate?(coordinate)
      if @game_data[:computer][:board].cells[coordinate].fired_upon?
        return "already fired"
      else
        @game_data[:computer][:board].cells[coordinate].fire_upon
        turn = Turn.new(coordinate, @game_data[:player], @game_data[:computer])
        add_turn(turn)
        return true
      end
    else
      false
    end
  end

  def take_computer_turn
    if  @turns.length < 3 || @smart != true
      coordinate = @computer_shot_choices.sample
      @game_data[:player][:board].cells[coordinate].fire_upon
      turn = Turn.new(coordinate, @game_data[:computer], @game_data[:player])
      add_turn(turn)
      @computer_shot_choices.delete(coordinate)

      check_for_winner
    else

      keys =  @game_data[:player][:board].cells.keys


      if @game_data[:player][:board].cells[(@turns[-2].coordinate)].render == "H"
        coord = @turns[-2].coordinate

        if @direction == nil
          keys = keys.keep_if do |key|
            (keys.index(key) / @board_columns) == ((keys.index(coord) / @board_columns) + 1) && key[1] == coord[1] ||
            (keys.index(key) / @board_columns) == ((keys.index(coord) / @board_columns) - 1) && key[1] == coord[1] ||
            keys.index(key) == (keys.index(coord) + 1 ) && key[0] == coord[0] ||
            keys.index(key) == (keys.index(coord) - 1) && key[0] == coord[0]
          end
        elsif @direction == "horizontal"
          keys = keys.keep_if do |key|
            keys.index(key) == (keys.index(coord) + 1 ) && key[0] == coord[0] ||
            keys.index(key) == (keys.index(coord) - 1) && key[0] == coord[0]
          end
        elsif @direction == "vertical"
          keys = keys.keep_if do |key|
            (keys.index(key) / @board_columns) == ((keys.index(coord) / @board_columns) + 1) && key[1] == coord[1] ||
            (keys.index(key) / @board_columns) == ((keys.index(coord) / @board_columns) - 1) && key[1] == coord[1]
          end
        end


        keys = keys.select do |key|
          @game_data[:player][:board].cells[key].fired_upon? == false
        end

        coordinate = keys.sample
        @game_data[:player][:board].cells[coordinate].fire_upon
        turn = Turn.new(coordinate, @game_data[:computer], @game_data[:player])
        add_turn(turn)
        if @game_data[:player][:board].cells[(@turns[-1].coordinate)].render == "H"
          if @turns[-1].coordinate[0] == @turns[-3].coordinate[0]
            @direction = "horizontal"
          else
            @direction = "vertical"
          end
        end
        @computer_shot_choices.delete(coordinate)
        check_for_winner
      else
        coordinate = @computer_shot_choices.sample
        @game_data[:player][:board].cells[coordinate].fire_upon
        turn = Turn.new(coordinate, @game_data[:computer], @game_data[:player])
        add_turn(turn)
        @computer_shot_choices.delete(coordinate)

        check_for_winner
      end
    end
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





end
