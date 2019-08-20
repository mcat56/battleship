require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < MiniTest::Test

  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser",3)
    @voyager = Ship.new("Voyager",4)
  end

  def test_it_exists
    assert_instance_of Cell, @cell
  end

  def test_it_has_a_coordinate
    assert_equal "B4", @cell.coordinate
  end

  def test_ship
    assert_nil @cell.ship
  end

  def test_empty?
    assert @cell.empty?
  end

  def test_place_ship
    assert @cell.empty?
    @cell.place_ship(@cruiser)
    refute @cell.empty?
  end

  def test_ship
    assert_nil @cell.ship
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
  end

  def test_fired_upon?
    refute @cell.fired_upon?
    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def test_fire_upon
    refute @cell.fired_upon?

    @cell.fire_upon
    assert @cell.fired_upon?
  end

  def test_render
    assert_equal ".", @cell.render
    @cell.fire_upon
    assert_equal "M", @cell.render

    cell_2 = Cell.new("C3")
    cell_2.place_ship(@cruiser)
    assert_equal ".", cell_2.render
    assert_equal "S", cell_2.render(true)
    cell_2.fire_upon
    assert_equal "H", cell_2.render

    cell_3 = Cell.new("D5")
    cell_3.place_ship(@voyager)
    assert_equal "S", cell_3.render(true)
    cell_3.fire_upon
    cell_3.ship.hit
    cell_3.ship.hit
    cell_3.ship.hit
    cell_3.ship.hit
    assert_equal "X", cell_3.render
  end

end
