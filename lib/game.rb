class Game
attr_reader :game_data

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
    generate_game_data
  end

  def generate_game_data
    players = generate_players
    # require 'pry'; binding.pry
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



  def place_ships
    @game_data.each do |player, hash|
      if hash[:player].is_human? == false
        hash[:ships].each do |ship|
          generate_valid_computer_placement(ship)
          hash[:board].place(ship,@found)
        end
      else
        puts """
        You need to lay out your #{hash[:ships].length} ships.
        """
        hash[:ships].each do |ship|
          puts "The #{ship.name} is #{ship.length} units long.\n"
        end
          puts "#{@player_board.render}"

        hash[:ships].each do |ship|
          puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
          coordinates = gets.chomp
          if hash[:board].valid_placment?(ship,coordinates)
            hash[:board].place(ship,coordinates)
          else
            until hash[:board].valid_placment?(ship,coordinates)
              puts "Those are invalid coordinates. Please try again."
              coordinates = gets.chomp
            end
            hash[:board].place(ship,coordinates)
          end
        end
      end
    end
  end

  def generate_valid_computer_placement(ship)
    start = @computer_board.cells.keys.sample
    coordinate_options = @computer_board.generate_valid_coordinates(start)
    @found = coordinate_options.find do |cooordinates|
       @computer_board.valid_placement?(ship,coordinates)
     end
      if @found == nil
        generate_valid_computer_placement(ship)
      else
        @found
      end
  end

  def take_turn_single_player
      @game_data.each do |player,hash|
        if hash[player].is_human?
          keys = hash[player][:board].cells.keys
          shot = hash[player][:board].cells.keys.sample
          hash[player][:board].cells[shot].fire_upon
          @turns << Turn.new(shot,"computer", @players[0])
          keys.delete(shot)
        else
          puts "Enter the coordinate for your shot:"
          @shot = gets.chomp
            if @attempts[@shot] == 1
              "You have already fired here. Select a new coordinate."
            elsif @attempts[@shot] >= 1
              return
            elsif @game_data[:computer][:board].valid_coordinate?(@shot) == true
              @game_data[:computer][:board].cells[@shot].fire_upon
              @turns << Turn.new(@shot,players[0], "computer")
              @attempts[@shot] += 1
            else
              until @game_data[:computer][:board].valid_coordinate?(@shot) == true
                puts "Please enter a valid coordinate:"
                @shot = gets.chomp
              end
              @game_data[:computer][:board].cells[@shot].fire_upon
              @attempts[@shot] += 1
              @turns << Turn.new(@shot,players[0], "computer")
            end
          end
        end
    end

    def take_turn_multi_player
      players = []
      @game_data.each do |player,hash|
        players << hash[:player]
      end
        attacker = players.sample
        if players.length == 2
          players.delete(attacker)
          defender = players.sample
        else
          puts "Enter the player you wish to attack"
          defender = gets.chomp
          puts "#{attacker.name} enter the coordinate for your shot:"
          @shot = gets.chomp
            if @attempts[@shot] == 1
              "You have already fired here. Select a new coordinate."
            elsif @attempts[@shot] >= 1
              return
            elsif @game_data[  ?????    ].valid_coordinate?(@shot) == true
              @game_data[:computer][:board].cells[@shot].fire_upon
              @attempts[@shot] += 1
            else
              until @game_data[:computer][:board].valid_coordinate?(@shot) == true
                puts "Please enter a valid coordinate:"
                @shot = gets.chomp
              end
              @game_data[:computer][:board].cells[@shot].fire_upon
              @attempts[@shot] += 1
            end
          end
        end
      end
    end



      def display_the_boards
        puts """
        =============COMPUTER BOARD=============
        #{@computer_board.render}
        ==============PLAYER BOARD==============
        #{@player_board.render(true)}
        """
      end

      def user_result
        if @attempts[@shot] > 1
            @user_result = "You repeated a previous fire."
        elsif @computer_board.cells[@shot].render == "M"
          @user_result = "Your shot on #{@shot} was a miss."
        elsif @computer_board.cells[@shot].render == "H"
          @user_result = "Your shot on #{@shot} was a hit!"
        elsif @computer_board.cells[@shot].render == "X"
          @user_result = "Your shot on #{@shot} sunk the ship!"
        end
      end

      def computer_result
        if @player_board.cells[@sample].render == "M"
          @computer_result = "My shot on #{@shot} was a miss."
        elsif @player_board.cells[@sample].render == "H"
          @computer_result = "My shot on #{@shot} was a hit!"
        elsif @player_board.cells[@sample].render == "X"
          @computer_result = "My shot on #{@sample} sunk the ship!"
        end
      end

      def display_results
        puts """
        #{@user_result}
        #{@computer_result}
        """
      end


end
