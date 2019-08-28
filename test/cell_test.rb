require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @cell = Cell.new("B4")
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_has_coordinate
    assert_equal "B4", @cell.coordinate
  end

  def test_ship_starts_empty
    assert_nil @cell.ship
  end

  def test_cell_equality
    equal_cell = Cell.new("B4")
    assert_equal true, @cell == equal_cell
  end

  def test_empty?
    assert_equal true, @cell.empty?

    @cell.place_ship(@cruiser)
    assert_equal false,  @cell.empty?
  end

  def test_can_place_ship
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
  end

  def test_fired_upon?
    # Cell should not be fired upon when initialized
    # Should return true after the cell has been fired upon
    assert_equal false, @cell.fired_upon?
    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def test_fire_upon
    refute @cell.fired_upon?
    @cell.fire_upon
    assert @cell.fired_upon?

    # It should not change the state of fired_upon? or ship health when fire_upon is called again
    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def test_render_for_empty_cell
    assert_equal ".", @cell.render
    @cell.fire_upon
    assert_equal "M", @cell.render
 end

  def test_render_for_cell_containing_ship
    @cell_2 = Cell.new("C3")
    @cell.place_ship(@cruiser)
    assert_equal ".", @cell_2.render(true)
    assert_equal ".", @cell.render
    assert_equal "S", @cell.render(true)
  end

   def test_render_for_hit_cell
    @cell_2 = Cell.new("C3")
    @cell.place_ship(@cruiser)
    @cell.fire_upon
    assert_equal "H", @cell.render
    assert_equal "H", @cell.render(true)
  end

  def test_render_when_ship_sunk
    @cell.place_ship(@cruiser)
    @cell.fire_upon
    @cruiser.hit
    @cruiser.hit
    assert_equal "X", @cell.render
    assert_equal "X", @cell.render(true)
  end

end
