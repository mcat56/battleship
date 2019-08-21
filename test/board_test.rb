require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'


class BoardTest < MiniTest::Test

  def setup
    @cell_A1 = Cell.new("A1")
    @cell_A2 = Cell.new("A2")
    @cell_A3 = Cell.new("A3")
    @cell_A4 = Cell.new("A4")
    @cell_B1 = Cell.new("B1")
    @cell_B2 = Cell.new("B2")
    @cell_B3 = Cell.new("B3")
    @cell_B4 = Cell.new("B4")
    @cell_C1 = Cell.new("C1")
    @cell_C2 = Cell.new("C2")
    @cell_C3 = Cell.new("C3")
    @cell_C4 = Cell.new("C4")
    @cell_D1 = Cell.new("D1")
    @cell_D2 = Cell.new("D2")
    @cell_D3 = Cell.new("D3")
    @cell_D4 = Cell.new("D4")
    @cells = {
      "A1" => @cell_A1,
      "A2" => @cell_A2,
      "A3" => @cell_A3,
      "A4" => @cell_A4,
      "B1" => @cell_B1,
      "B2" => @cell_B2,
      "B3" => @cell_B3,
      "B4" => @cell_B4,
      "C1" => @cell_C1,
      "C2" => @cell_C2,
      "C3" => @cell_C3,
      "C4" => @cell_C4,
      "D1" => @cell_D1,
      "D2" => @cell_D2,
      "D3" => @cell_D3,
      "D4" => @cell_D4
    }
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  def test_it_exists
    assert_instance_of Board, @board
  end

  def test_it_makes_a_board
    assert_instance_of Hash, @board.cells
    @board.create_board
    refute_nil @board.cells
    assert_equal "A1", @cells.key(@cell_A1)
    assert_instance_of Cell, @board.cells.values
    assert_equal 16, @board.length * @board.width
    @cells.each do |key,value|
      assert_equal true, value == @board.cells[key]
    end
  end

  def test_makes_alphabetical_coordinate
    assert_equal "Z", @board.calculate_alphabetical_coordinate(26)
    assert_equal "AB", @board.calculate_alphabetical_coordinate(28)
    assert_equal "AAA", @board.calculate_alphabetical_coordinate(677)
  end


  def test_it_has_cells_hash
    assert_instance_of Hash, @board.cells
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

  def test_render
    @board.place(@cruiser,["A1","A2","A3"])
    assert_equal "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n", @board.render
    assert_equal "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n", @board.render(true)
    @board.cells["A1"].fire_upon
    assert_equal "  1 2 3 4 \nA H S S . \nB . . . . \nC . . . . \nD . . . . \n", @board.render(true)
    @board.cells["B2"].fire_upon
    assert_equal "  1 2 3 4 \nA H S S . \nB . M . . \nC . . . . \nD . . . . \n", @board.render(true)
    @board.cells["A2"].fire_upon
    assert_equal "  1 2 3 4 \nA H H S . \nB . M . . \nC . . . . \nD . . . . \n", @board.render(true)
    @board.cells["A3"].fire_upon
    assert_equal "  1 2 3 4 \nA X X X . \nB . M . . \nC . . . . \nD . . . . \n", @board.render(true)
  end




end
