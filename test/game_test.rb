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
    @player = Player.new("player", true)
    @computer = Player.new("computer", false)
    @p_cruiser = Ship.new("Cruiser",3)
    @p_submarine = Ship.new("Submarine",2)
    @p_board = Board.new
    @c_cruiser = Ship.new("Cruiser",3)
    @c_submarine = Ship.new("Submarine",2)
    @c_board = Board.new
    @game = Game.new(["player"])
    @game_data = {player: {
                    player: @player,
                    ships: [@p_submarine, @p_cruiser],
                    board: @p_board },
                  computer: {
                    player: @computer,
                    ships: [@c_submarine, @c_cruiser],
                    board: @c_board }
      }
    end

  def test_it_exists
    assert_instance_of Game, @game
  end

  def test_generate_game_data
    @game_data.each do |key, player|
      # require 'pry'; binding.pry
      assert_equal player[:player], @game.game_data[key][:player]
      # assert_equal player[:ships], @game.game_data[key][:ships]
      player[:ships].each_index do |index|
        assert_equal true, @game.game_data[key][:ships][index].eql?(player[:ships][index])
      end
      assert_equal player[:board], @game.game_data[key][:board]
    end
  end

  def test_place_ships
    @p_board.place(@p_cruiser, ["A1", "A2", "A3"])
    @p_board.place(@p_submarine, ["C2", "D2"])
    assert_nil @p_board.cells["B3"].ship
    assert_nil @p_board.cells["A4"].ship
    assert_equal @p_board.cells["A1"].ship, @p_cruiser
    assert_equal @p_board.cells["A2"].ship, @p_cruiser
    assert_equal @p_board.cells["A3"].ship, @p_cruiser
    assert_equal @p_board.cells["C2"].ship, @p_submarine
    assert_equal @p_board.cells["D2"].ship, @p_submarine

    @c_board.cells.keys.each do |key|
      assert_nil @c_board.cells[key].ship
    end

    @c_board.place(@c_cruiser, ["A1", "A2", "A3"])
    @c_board.place(@c_submarine, ["C2", "D2"])
    assert_nil @c_board.cells["B3"].ship
    assert_nil @c_board.cells["A4"].ship
    assert_equal @c_board.cells["A1"].ship, @c_cruiser
    assert_equal @c_board.cells["A2"].ship, @c_cruiser
    assert_equal @c_board.cells["A3"].ship, @c_cruiser
    assert_equal @c_board.cells["C2"].ship, @c_submarine
    assert_equal @c_board.cells["D2"].ship, @c_submarine
  end

  def test_a_turn
    turn1 = Turn.new("B2", @game_data[:player], @game_data[:computer])
    @game.add_turn(turn1)
    assert_equal turn1, @game.turns.last
  end

  def test_feedback_for_miss
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][1], ["A1", "A2", "A3"])
    @game.game_data[:computer][:board].place(@game.game_data[:computer][:ships][0], ["A1", "A2"])
    @game.game_data[:computer][:board].cells["D1"].fire_upon
    @game.game_data[:player][:board].cells["D3"].fire_upon
    turn1 = Turn.new("D1", @game.game_data[:player], @game.game_data[:computer])
    turn2 = Turn.new("D3", @game.game_data[:computer], @game.game_data[:player])
    @game.add_turn(turn1)
    @game.add_turn(turn2)
    assert_equal "Your shot on D1 was a miss.\nMy shot on D3 was a miss.", @game.feedback
  end

  def test_feedback_for_hit
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][1], ["A1", "A2", "A3"])
    @game.game_data[:computer][:board].place(@game.game_data[:computer][:ships][0], ["A1", "A2"])
    @game.game_data[:computer][:board].cells["A1"].fire_upon
    @game.game_data[:player][:board].cells["A1"].fire_upon
    turn1 = Turn.new("A1", @game.game_data[:player], @game.game_data[:computer])
    turn2 = Turn.new("A1", @game.game_data[:computer], @game.game_data[:player])
    @game.add_turn(turn1)
    @game.add_turn(turn2)
    assert_equal "Your shot on A1 was a hit!\nMy shot on A1 was a hit!", @game.feedback
  end

  def test_feedback_for_sunk
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][1], ["A1", "A2", "A3"])
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:computer][:board].place(@game.game_data[:computer][:ships][0], ["A1", "A2"])
    @game.game_data[:computer][:ships][0].hit
    @game.game_data[:computer][:ships][0].hit
    @game.game_data[:computer][:board].cells["A1"].fire_upon
    @game.game_data[:player][:board].cells["A1"].fire_upon
    turn1 = Turn.new("A1", @game.game_data[:player], @game.game_data[:computer])
    turn2 = Turn.new("A1", @game.game_data[:computer], @game.game_data[:player])
    @game.add_turn(turn1)
    @game.add_turn(turn2)
    assert_equal "Your shot on A1 sunk my Submarine!\nMy shot on A1 sunk your Cruiser!", @game.feedback
  end


  def test_ships_to_add
    assert_equal 0, @game.ships_to_add
    game2 = Game.new(["player"],10,10)
    assert_equal 3, game2.ships_to_add
  end

  def test_generate_ships
    game_2 = Game.new(["player"], 10, 10)
    submarine = Ship.new("Submarine", 2)
    cruiser = Ship.new("Cruiser", 3)
    destroyer = Ship.new("Destroyer", 3)
    battleship = Ship.new("Battleship", 4)
    carrier = Ship.new("Carrier", 5)
    assert_equal true, [submarine, cruiser].eql?(@game.generate_ships)
    assert_equal true, [submarine, cruiser, destroyer, battleship, carrier].eql?(game_2.generate_ships)
  end

  def test_custom_ships
    game = Game.new(["player"], 4, 4, true, {"Voyager" => 3, "Discovery" => 2})
    voyager = Ship.new("Voyager", 3)
    discovery = Ship.new("Discovery", 2)
    assert_equal true, [voyager,discovery].eql?(game.generate_ships)
  end

  def test_custom_board
    game = Game.new(["player"], 10, 10, false)
    assert_equal 100, game.game_data[:player][:board].cells.length
    assert_equal 100, game.game_data[:computer][:board].cells.length
  end

  def test_custom_board_and_ships
  end


  def test_generate_players
    player1 = Player.new("player",true)
    player2 = Player.new
    assert_equal [player1,player2], @game.generate_players
  end

  def test_display_the_boards
    board_string = "=============COMPUTER BOARD=============\n#{@game_data[:computer][:board].render}==============PLAYER BOARD==============\n#{@game_data[:player][:board].render(true)}"

    assert_equal board_string, @game.display_boards
  end

  def test_adds_a_turn
    turn1 = Turn.new("A1", @game_data[:player], @game_data[:computer])
    turn2 = Turn.new("A1", @game_data[:computer], @game_data[:player])
    @game.add_turn(turn1)
    assert_equal [turn1], @game.turns
    @game.add_turn(turn2)
    assert_equal [turn1, turn2], @game.turns
  end

  def test_winner?
    @game.check_for_winner
    assert_equal false, @game.winner?
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][1], ["A1", "A2", "A3"])
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][0], ["B1", "B2"])
    @game.game_data[:player][:ships][0].hit
    @game.game_data[:player][:ships][0].hit
    @game.check_for_winner
    assert_equal true, @game.winner?
  end

  def test_check_for_winner
    @game.check_for_winner
    assert_equal "", @game.winner
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][1], ["A1", "A2", "A3"])
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:ships][1].hit
    @game.game_data[:player][:board].place(@game.game_data[:player][:ships][0], ["B1", "B2"])
    @game.game_data[:player][:ships][0].hit
    @game.game_data[:player][:ships][0].hit
    @game.check_for_winner
    assert_equal "computer", @game.winner
  end


end
