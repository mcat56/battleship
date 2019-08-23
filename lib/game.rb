class Game

  def initialize
    @computer = Player.new
    @player = Player.new
    @turns = []
  end

  def welcome
    puts """
      Welcome to BATTLESHIP
      Enter p to play. Enter q to quit.
      """
    @choice = gets.chomp
    if @choice == p
      get_game_board_size
    else
      # close file????
    end
  end

  def get_game_board_size
    puts "Please enter a length for the boards"
    @length = gets.chomp
    puts "Please enter a width for the boards"
    @width = gets.chomp
  end

  def get_ship_number
    puts "How many ships would you like to play with?"
    ship_count = gets.chomp
  end

  def computer_place_cruiser
    @computer_board = Board.new(@length,@width)
    cruiser_coordinates = @computer_board.cells.keys.sample(3)
     if @computer_board.valid_placement?(@computer.cruiser,cruiser_coordinates)
       @computer_board.place(@computer.cruiser, cruiser_coordinates)
    else
      computer_place_cruiser
    end
  end

  def computer_place_submarine
    @computer_board = Board.new(@length,@width)
    submarine_coordinates = @computer_board.cells.keys.sample(3)
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
    """
    @player_board = Board.new(@length,@width)
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @player_board.render
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
      else
        @computer.ships.any? do |ship|
          if ship.sunk? == true
            puts "You won!"
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
  end 



end
