require './minitest/autorun'
require './minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'

class PlayerTest < MiniTest::Test

  def setup
    @player = Player.new("Mario")
    @player2 = Player.new
  end

  
