class Game
attr_reader :game_data
attr_accessor :ships, :boards

  def initialize(players = [], board = [], ships)
    @game_data = {}
    @players = []
    @attempts = Hash.new(0)
    @turns = [] 
    generate_game_data
  end

  def ==()

  def generate_game_data()
    @game_data[players[0] = Player.new]

  def generate_valid_placement_options
    cruiser_coordinate = @computer_board.cells.keys.sample
    @horizontal = @computer_board.generate_horizontal_coordinates(cruiser_coordinate)
    @vertical = @computer_board.generate_vertical_coordinates(cruiser_coordinate)
  end

  def computer_place_cruiser
    until @horizontal
    else
      generate_valid_placement_options
    end
  end

  def computer_place_submarine
    submarine_coordinate = @computer_board.cells.keys.sample

     if @computer_board.valid_placement?(@computer.submarine,submarine_coordinates)
       @computer_board.place(@computer.submarine, submarine_coordinates)
    else
      computer_place_submarine
    end
  end

  def user_place_ships
    puts """
    I have laid out my ships on the grid.
    You now need to lay out your two ships.
    The Cruiser is two units long and the Submarine is three units long.
    #{@player_board.render}
    """


    puts "Enter the squares for the Cruiser (3 spaces):"
    cruiser_coordinates = gets.chomp
      until @player_board.valid_placement?(@player.cruiser, cruiser_coordinates) == true
        puts "Those are invalid coordinates. Please try again:"
        cruiser_coordinates = gets.chomp
      end
    @player_board.place(@player.cruiser, cruiser_coordinates)
    @board.render(true)
    puts "Enter the squares for the Submarine (2 spaces):"
    submarine_coordinates = gets.chomp
      until @player_board.valid_placement?(@player.submarine,submarine_coordinates) == true
        puts "Those are invalid coordinates. Please try again:"
        submarine = gets.chomp
      end
      @player_board.place(@player.submarine, submarine_coordinates)
  end

  def play
    @player.ships.any? do |ship|
      if ship.sunk? == true
        puts "I won!"
        welcome
      end
    end
      else
        @computer.ships.any? do |ship|
          if ship.sunk? == true
            puts "You won!"
            welcome
            end
          else
            turn = Turn.new(@player_board,@computer_board)
            turn.display_the_boards
            turn.prompt_user_for_shot
            turn.user_fires
            turn.user_result
            turn.computer_result
            turn.display_results
            turn.display_the_boards
            play
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

      def get_coordinate
        puts "Enter the coordinate for your shot:"
        @shot = gets.chomp
        if valid_fire?(@shot)
          @shot = shot
        else
          "Please enter a valid coordinate:"
        end
      end

      def valid_fire?
        @player_board.valid_coordinate?(@shot) == true
      end

      def user_fires
        if @attempts[@shot] == 1
          "You have already fired here. Select a new coordinate."
        elsif attempts [coordinate] >= 1
          return
        else
          if valid_fire?
            @computer_board.cells[@shot].fire_upon
            @attempts[@shot] += 1
          else
            "Please enter a valid coordinate"
          end
        end
      end

      def computer_fire
        @sample = @player_keys.sample
        @player_board.cells[@sample].fire_upon
        @player_keys.delete(@sample)
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
