require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'


class BoardTest < MiniTest::Test

  def setup
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_has_cells
    assert_equal 16, @board.cells.length
    assert_instance_of Hash, @board.cells
    assert_instance_of Cell, @board.cells.values
  end

  def test_valid_coordinate?
    assert_equal true, @board.valid_coordinate?("A1")
    assert_equal false, @board.valid_coordinate?("E1")
  end

  def test_valid_placement?
    assert_equal true, @board.place(@cruiser,["A1","A2","A3"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "B1"])
  end

  def test_place
    @board.place(@cruiser,["A1","A2","A3"])
    assert_equal @cruiser, @board.cells("A1").ship
    assert_equal @cruiser, @board.cells("A2").ship
    assert_equal @cruiser, @board.cells("A3").ship
    @board.place(@submarine,["A1","A2"])
    assert_equal @cruiser, @board.cells("A1").ship
    assert_equal @cruiser, @board.cells("A2").ship
    assert_equal @cruiser, @board.cells("A3").ship
  end


end
