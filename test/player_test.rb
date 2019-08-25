require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'

class PlayerTest < MiniTest::Test

  def setup
    @player   = Player.new("Mario", true)
    @computer = Player.new
  end

  def test_equality
    player_2 = Player.new("Mario", true)

    assert_equal true, @player == player_2 
    assert_equal false, player_2 == @computer
  end

  def test_it_exists
    assert_instance_of Player, @player
  end

  def test_it_has_attributes
    assert_equal "Mario", @player.name
  end

  def test_default_computer_name
    assert_equal "computer", @computer.name
  end

  def test_default_to_computer_controlled
    assert_equal false, @computer.human?
  end

  def test_can_be_human_controlled
    assert_equal true, @player.human?
  end

end
