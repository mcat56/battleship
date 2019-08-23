require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'

class PlayerTest < MiniTest::Test

  def setup
    @player = Player.new("Mario",true)
    @computer = Player.new("computer",false)
  end

  def test_it_exists
    assert_instance_of Player, @player
    assert_instance_of Player, @computer
  end

  def test_it_has_a_name
    assert_equal "Mario",

end
