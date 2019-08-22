require './minitest/autorun'
require './minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'
require './lib/turn'
require './lib/game'

class GameTest < MiniTest::Test

  def setup
    @game = Game.new
  end

  def test_it_exists
    assert_instance_of Game, @game 
  end
