require 'minitest/autorun'
require 'minitest/pride'
require './lib/cell'
require './lib/ship'
require './lib/board'
require './lib/player'
require './lib/turn'
require './lib/game'

class GameTest < MiniTest::Test

  def setup
    @game = Game.new
    @player = Player.new("player", true)
    @computer = Player.new("computer", false)
    @p_cruiser = Ship.new("Cruiser",3)
    @p_submarine = Ship.new("Submarine",2)
    @p_board = Board.new
    @c_cruiser = Ship.new("Cruiser",3)
    @c_submarine = Ship.new("Submarine",2)
    @c_board = Board.new
    @game_data = { player: {player: @player,
                            ships: [@p_cruiser, @p_submarine],
                            board: @p_board },
                  computer: {computer: @computer,
                             ships: [@c_cruiser, @c_submarine],
                             board: @c_board}
                           }
  end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_game_data_is_a_hash
    assert_instance_of Hash, @game.game_data
  end

  def test_ships_start_with_cruiser_and_submarine
    assert_equal [@cruiser,@submarine], game.ships
  end

  def test_generate_game_data
    assert_equal @game_data, @game.game_data
  end

  def test_place_ships
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    @p_board.place(@p_submarine, ["C2", "D2"])
    assert_nil @p_board.cells["B3"]
    assert_nil @p_board.cells["A4"]
    assert_equal @p_board.cells["A1"].ship, @p_cruiser
    assert_equal @p_board.cells["A2"].ship, @p_cruiser
    assert_equal @p_board.cells["A3"].ship, @p_cruiser
    assert_equal @p_board.cells["C2"].ship, @p_submarine
    assert_equal @p_board.cells["D2"].ship, @p_submarine

    @c_board.cells.each do |cell|
      assert_nil cell.ship
    end

    @c_board.place(@c_cruiser, ["A1", "A2", "A3"])
    @c_board.place(@c_submarine, ["C2", "D2"])
    assert_nil @c_board.cells["B3"]
    assert_nil @c_board.cells["A4"]
    assert_equal @c_board.cells["A1"].ship, @c_cruiser
    assert_equal @c_board.cells["A2"].ship, @c_cruiser
    assert_equal @c_board.cells["A3"].ship, @c_cruiser
    assert_equal @c_board.cells["C2"].ship, @c_submarine
    assert_equal @c_board.cells["D2"].ship, @c_submarine
  end

  def test_a_turn
    turn1 = Turn.new("B2", @game_data[:player], @game[:computer])
    assert_equal turn1, @game.turns.last
    assert_equal true, @c_board.cells["B2"].fired_upon?
  end

  def test_feedback_for_miss
    turn1 = Turn.new("B2", @game_data[:player], @game[:computer])
    assert_equal "Your shot on B2 was a miss.", @game.turn_feedback
    turn2 = Turn.new("C3", @game_data[:computer, @game[:player])
    assert_equal "My shot on C3 was a miss.", @game.turn_feedback
  end

  def test_feedback_for_hit
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    turn1 = Turn.new("A1", @game_data[:computer, @game[:player])
    assert_equal "My shot on A1 was a hit!", @game.feedback
  end

  def test_feedback_for_sunk
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    turn1 = Turn.new("A1", @game_data[:computer, @game[:player])
    turn2 = Turn.new("A2", @game_data[:computer, @game[:player])
    turn3 = Turn.new("A3", @game_data[:computer, @game[:player])
    assert_equal "My shot on A3 sunk the ship!", @game.feedback(turn_3)
  end

  def test_turn_feedback
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    turn1 = Turn.new("A1", @game_data[:computer, @game[:player])
    turn2 = Turn.new("D3", @game_data[:player], @game_data[:computer])
    assert_equal "My shot on A1 was a hit!\nYour shot on D3 was a miss.", @game.feedback(turn1,turn2)
  end



  def test_game_over?
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    turn1 = Turn.new("A1", @game_data[:computer], @game_data[:player])
    turn2 = Turn.new("A2", @game_data[:computer], @game_data[:player])
    turn3 = Turn.new("A3", @game_data[:computer], @game_data[:player])
    @p_board.place(@p_submarine, ["C2", "D2"])
    assert_equal false, @game.game_over?(@game_data[:player])
    turn4 = Turn.new("C2", @game_data[:computer], @game_data[:player])
    turn5 = Turn.new("D2", @game_data[:computer], @game_data[:player])
    assert_equal true, @game.game_over?(@game_data[:player])
  end

  def test_end_game_feedback
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    turn1 = Turn.new("A1", @game_data[:computer], @game_data[:player])
    turn2 = Turn.new("A2", @game_data[:computer], @game_data[:player])
    turn3 = Turn.new("A3", @game_data[:computer], @game_data[:player])
    @p_board.place(@p_submarine, ["C2", "D2"])
    turn4 = Turn.new("C2", @game_data[:computer], @game_data[:player])
    turn5 = Turn.new("D2", @game_data[:computer], @game_data[:player])
    assert_equal "I won!", @game.winner_feedback
  end
