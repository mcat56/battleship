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

  def test_empty?
    assert @cell.empty?

    @cell.place_ship(@cruiser)
    refute @cell.empty?
  end

  def test_place_ship
    assert_nil @cell.ship

    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
  end

  def test_fired_upon?
    # Cell should not be fired upon when initialized
    # Should return true after the cell has been fired upon
    refute @cell.fired_upon?
    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def fire_upon
    refute @cell.fired_upon?
    @cell.fire_upon
    assert @cell.fired_upon?
    # It should not change the state of fired_upon? or ship health when fire_upon is called again
    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def render
    # No ship
    assert_equal ".", @cell.render
    @cell.fire_upon
    assert_equal "M", @cell.render

    # Has ship
    # Should render S if a ship exists and has not been hit/sunk
    @cell = Cell.new("B4")
    @cell.place_ship(@cruiser)
    assert_equal ".", @cell.render
    assert_equal "S", @cell.render(true)

    # Should always render H if ship is not sunk
    @cell.fire_upon
    assert_equal "H", @cell.render
    assert_equal "H", @cell.render(true)

    # Should always render X if sunk
    @cruiser.hit
    @cruiser.hit
    assert_equal "X", @cell.render
    assert_equal "X", @cell.render(true)
  end

end