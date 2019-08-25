require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'
require './lib/turn'


class TurnTest < MiniTest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
    @player = Player.new("Mario", true)
    @computer = Player.new
    @player_board = Board.new
    @computer_board = Board.new
    game_hash = {
      player1: {
        player: @player,
        ships: [@cruiser, @submarine],
        board: @player_board
      },
      player2: {
        player: @computer,
        ships: [@cruiser, @submarine],
        board: @computer_board
      }
    }

    @turn = Turn.new("A1",game_hash[:player1], game_hash[:player2])
  end

  def test_it_exists
    assert_instance_of Turn, @turn
  end

  def test_it_has_attributes
    assert_equal "A1", @turn.coordinate
    assert_equal game_hash[:player1], @turn.attacker_hash
    assert_equal game_hash[:player2], @turn.defender_hash
  end



end
