class Turn

  def initialize(player_board,computer_board)
    @user = user
    @player_board = player_board
    @computer_board = computer_board
    attempts = Hash.new(0)
    @player_keys = @player_board.cells.keys
  end

  def display_the_boards
    puts """
    =============COMPUTER BOARD=============
    #{@computer_board.render}
    ==============PLAYER BOARD==============
    #{@player_board.render(true)}
    """
  end

  def prompt_for_user_shot
    puts "Enter the coordinate for your shot:"
    @shot = gets.chomp
    if @player_board.valid_fire?(@shot)
      @shot = shot
    else
      "Please enter a valid coordinate:"
  end

  def valid_fire?
    @player_board.valid_coordinate?(@shot) == true
  end

  def user_fires
    if attempts[@shot] == 1
      "You have already fired here. Select a new coordinate."
    elsif attempts [coordinate] >= 1
      return
    else
      if valid_fire?
        @computer_board.cells[@shot].fire_upon
        attempts[@shot] += 1
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
    if attempts.values.any? do |value|
      if value > 1
        @user_result = "You repeated a previous fire."
      end
      end
    end
    if @computer_board.cells[@shot].render == "M"
      @user_result = "Your shot on #{@shot} was a miss."
    elsif @computer_board.cells[@shot].render == "S"
      @user_result = "Your shot on #{shot} was a hit!"
    elsif @computer_board.cells[@shot].render == "X"
      @user_result = "Your shot on #{@shot} sunk the ship!"
    end
  end

  def computer_result
    if @player_board.cells[@sample].render == "M"
      @computer_result = "My shot on #{@shot} was a miss."
    elsif @player_board.cells[@sample].render == "S"
      @computer_result = "My shot on #{shot} was a hit!"
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
