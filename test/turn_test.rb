require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'
require './lib/turn'


class TurnTest < MiniTest::Test

  def setup
    @player = Player.new
    @turn = Turn.new
  end

  def test_it_exists
    assert_instance_of Turn, @turn
  end

  def test_coordinate_is_valid
    @turn.prompt_for_user_shot
    assert_equal true, @turn.valid_fire?
  end

  def test_feedback_to_user_invalid_coordinate
    @turn.prompt_user_for_shot
    assert_equal "Please enter a valid coordinate", @turn.user_fire(@shot)
  end

  def test_valid_fire?
    @turn.prompt_user_for_shot
    assert_equal true, @turn.valid_fire?(@shot)
  end

  def test_it_displays_user_results_for_miss
    #must test using input on known empty space
    @turn.prompt_user_for_shot
    @turn.user_fire(@shot)
    assert_equal "Your shot on #{@shot} was a miss.", @turn.user_result
  end

  def test_it_displays_user_results_for_hit
    #must test using input on known ship
    @turn.prompt_user_for_shot
    @turn.user_fire(@shot)
    assert_equal "Your shot on #{@shot} was a hit!", @turn.user_result
  end

  def test_it_displays_user_results_for_sink
    #must test using input on known ship with 1 hit left
    @turn.prompt_user_for_shot
    @turn.user_fire(@shot)
    assert_equal "Your shot on #{@shot} sunk the ship!", @turn.user_result
  end

  def test_it_displays_all_results
    @turn.prompt_user_for_shot
    @turn.user_fire(@shot)
    @computer_turn.computer_fire
    assert_equal  "" + "\n" + "" , @turn.display_results
  end



end
