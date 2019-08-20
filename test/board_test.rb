require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'


class BoardTest < MiniTest::Test

  def setup
    @board = Board.new
  end

  def test_it_has_cells
    assert_equal 16, @board.cells.length
    assert_instance_of Hash, @board.cells
    assert_instance_of Cell, @board.cells.values
  end

  def test_valid_coordinate?
    assert @board.valid_coordinate?("A1")
    refute @board.valid_coordinate?("E1")
  end

  def test_valid_placement?
    assert_equal cruiser.length, coordinates.length
    #more code
  end
end
