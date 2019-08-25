
  def welcome
    puts """
      Welcome to BATTLESHIP
      Enter p to play QuickMatch (4x4 Board)
      Enter c to play Classic (10x10 Board)
      Enter u to play Unique (custom board)
      Enter q to quit.
      """
    @choice = gets.chomp
    if @choice == p
      @columns = 4 && @rows = 4
    elsif @choice == c
      @columns = 10 && @rows = 10
    elsif @choice == u
      get_game_board_size
    elsif @choice == q
      return
    end
  end

  def get_player_count
    puts """
    Please select from the following options:
    Enter s for Single Player(Player vs Computer)
    Enter m for Multi-Player(Player vs Player)
    Otherwise enter the number of players you would like to play with
    """
    player_count = gets.chomp
    


  def get_game_board_size
    puts "Please enter a length for the boards"
    @length = gets.chomp
    puts "Please enter a width for the boards"
    @width = gets.chomp
  end

  #
  # def get_ship_number
  #   puts "How many ships would you like to play with?"
  #   ship_count = gets.chomp
  # end
