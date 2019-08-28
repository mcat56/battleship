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
    @board.cells.each do |key,value|
      assert_equal true, value == @cells[key]
    end
  end

  def test_makes_alphabetical_coordinate
    assert_equal "A", @board.calculate_alphabetical_coordinate(1)
    assert_equal "B", @board.calculate_alphabetical_coordinate(2)
    assert_equal "C", @board.calculate_alphabetical_coordinate(3)
    assert_equal "D", @board.calculate_alphabetical_coordinate(4)
    assert_equal "Z", @board.calculate_alphabetical_coordinate(26)
    assert_equal "AA", @board.calculate_alphabetical_coordinate(27)
    assert_equal "AZ", @board.calculate_alphabetical_coordinate(52)
    assert_equal "BA", @board.calculate_alphabetical_coordinate(53)
    assert_equal "CC", @board.calculate_alphabetical_coordinate(81)
    assert_equal "AAA", @board.calculate_alphabetical_coordinate(703)
    assert_equal "AAAB", @board.calculate_alphabetical_coordinate(18280)
  end

  def test_coordinate_is_valid
    assert_equal true, @board.valid_coordinate?("A1")
  end
  
  def test_coordinate_is_invalid
    assert_equal false, @board.valid_coordinate?("E1")
  end

  def test_valid_placement
    assert_equal true, @board.valid_placement?(@submarine, ["A1", "B1"])
    assert_equal true, @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert_equal true, @board.valid_placement?(@submarine, ["D3", "D4"])
    assert_equal true, @board.valid_placement?(@submarine, ["C3", "D3"])
  end

  def test_invalid_placement
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "D1"])
    assert_equal false, @board.valid_placement?(@submarine, ["A1", "A2", "A3"])
    assert_equal false, @board.valid_placement?(@submarine, ["A3", "D4"])
  end

  def test_valid_placement_coordinate_and_ship_length_must_match
    assert_equal false, @board.valid_placement?(@cruiser, ["A1"])
  end

  def test_valid_placement_cannot_go_off_board
    assert_equal false, @board.valid_placement?(@cruiser, ["E5", "E6", "E7"])
  end

  def test_valid_placement_cannot_go_bottom_to_top
    assert_equal false, @board.valid_placement?(@cruiser, ["D4", "C4", "B4"])
  end

  def test_valid_placement_must_be_consecutive
    assert_equal false, @board.valid_placement?(@cruiser, ["A1", "A3", "A2"])
  end

  def test_valid_placement_cannot_be_backwards
    assert_equal false, @board.valid_placement?(@cruiser, ["A3", "A2", "A1"])
  end

  def test_bottom_to_top_across_or_down?
    assert_equal false, @board.across_or_down?(["D4", "C4", "B4"])
  end

  def test_not_consecutive_across_or_down?
    assert_equal false, @board.across_or_down?(["A1", "A3", "A2"])
  end

  def test_backwards_across_or_down?
    assert_equal false, @board.across_or_down?(["A3", "A2", "A1"])
  end

  def test_generate_valid_horizontal_coordinates
    assert_equal ["A1", "A2", "A3"], @board.generate_horizontal_coordinates(["A1", "A2", "A3"], 3)
    assert_equal ["A1", "A2"], @board.generate_horizontal_coordinates(["A1", "B2"], 2)
    assert_equal ["D1", "D2", "D3", "D4"], @board.generate_horizontal_coordinates(["D1", "val", "doesn't", "matter"], 4)
  end

  def test_generate_invalid_horizontal_coordinates
    assert_equal [], @board.generate_horizontal_coordinates(["A3", "A4", "A5"], 3)
    assert_equal [], @board.generate_horizontal_coordinates(["D3", "B4", "B5"], 3)
    assert_equal [], @board.generate_horizontal_coordinates(["C2", "value", "doesn't", "matter"], 4)
  end

  def test_generate_valid_vertical_coordinates
    assert_equal ["A1", "B1", "C1"], @board.generate_vertical_coordinates(["A1", "B1", "C1"], 3)
    assert_equal ["A2", "B2"], @board.generate_vertical_coordinates(["A2", "D2"], 2)
    assert_equal ["A1", "B1", "C1", "D1"], @board.generate_vertical_coordinates(["A1", "val", "doesn't", "matter"], 4)
  end

  def test_generate_invalid_vertical_coordinates
    assert_equal [], @board.generate_horizontal_coordinates(["A3", "A4", "A5"], 3)
    assert_equal [], @board.generate_horizontal_coordinates(["D3", "B4", "B5"], 3)
    assert_equal [], @board.generate_horizontal_coordinates(["C2", "value", "doesn't", "matter"], 4)
  end

  def test_generate_valid_coordinate_pairs
    assert_equal [["A1", "A2", "A3"], ["A1", "B1", "C1"]], @board.generate_valid_coordinates(["A1", "A2", "A3"], 3)
    assert_equal [["D1", "D2", "D3", "D4"], []], @board.generate_valid_coordinates(["D1", "val", "doesn't", "matter"], 4)
    assert_equal [[], ["C4", "D4"]], @board.generate_valid_coordinates(["C4", "D2"], 2)
    assert_equal [[], []], @board.generate_valid_coordinates(["C3", "A4", "A5"], 3)
  end

  def test_valid_placement_cannot_overlap_ships
    @board.cells["D2"].place_ship(@submarine)
    assert_equal false, @board.valid_placement?(@cruiser, ["B2", "C2", "D2"])
  end

  def test_place
    @board.place(@cruiser,["A1", "A2", "A3"])
    assert_equal @cruiser, @board.cells["A1"].ship
    assert_equal @cruiser, @board.cells["A2"].ship
    assert_equal @cruiser, @board.cells["A3"].ship

    @board.place(@submarine,["A1", "A2"])
    assert_equal @cruiser, @board.cells["A1"].ship
    assert_equal @cruiser, @board.cells["A2"].ship
    assert_equal @cruiser, @board.cells["A3"].ship
  end

  def test_render
    @board.place(@cruiser, ["A1","A2","A3"])
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
    assert_equal "  1 2 3 4 \nA X X X . \nB . M . . \nC . . . . \nD . . . . \n", @board.render
    @board.place(@submarine, ["C2", "D2"])
    assert_equal "  1 2 3 4 \nA X X X . \nB . M . . \nC . . . . \nD . . . . \n", @board.render
    assert_equal "  1 2 3 4 \nA X X X . \nB . M . . \nC . S . . \nD . S . . \n", @board.render(true)
  end

  def test_constructs_a_rendered_row
    columns = 1..@board.columns
    @board.cells["C3"].place_ship(@cruiser)
    assert_equal "A . . . . ", @board.construct_row_render(1, columns, 1, false)
    assert_equal "B . . . . ", @board.construct_row_render(2, columns, 1, false)
    assert_equal "C . . S . ", @board.construct_row_render(3, columns, 1, true)
  end

  def test_ship_and_coordinates_are_same_length
    assert_equal true, @board.same_length?(@cruiser, ["A1", "A2", "A3"])
  end

  def test_ship_and_coordinates_are_not_same_length
    assert_equal false, @board.same_length?(@cruiser, ["A1", "A2"])
  end

  def test_all_coordinates_exist
    assert_equal true, @board.all_valid_coordinates?(["A1", "A2", "A3"])
  end

  def test_at_least_one_coordinate_does_not_exist
    assert_equal false, @board.all_valid_coordinates?(["D10", "A4"])
  end

  def test_all_cells_empty
    assert_equal true, @board.all_empty?(["A1", "A2", "A3"])
  end

  def test_at_least_one_cell_is_occupied
    @board.cells["A1"].place_ship(@cruiser)
    assert_equal false, @board.all_empty?(["A1", "A2", "A3"])
  end

  def test_custom_board_size
    board = Board.new(10, 52)
    board_2 = Board.new(52, 10)

    assert_equal 520, board.cells.length
    assert_equal 520, board_2.cells.length
  end

end
