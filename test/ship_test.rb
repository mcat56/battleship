require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'

class ShipTest < Minitest::Test

  def setup
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Ship, @cruiser
  end

  def test_has_name
    assert_equal "Cruiser", @cruiser.name
  end

  def test_has_length
    assert_equal 3, @cruiser.length
  end

  def test_health
    assert_equal 3, @cruiser.health
    @cruiser.hit
    assert_equal 2, @cruiser.health
  end

  def test_equality
    cruiser = Ship.new("Cruiser", 3)
    assert_equal true, @cruiser == cruiser

    submarine = Ship.new("Submarine", 2)
    assert_equal false, @cruiser == submarine
  end

  def test_sunk?
    # It should not be sunk until it's hit three times
    refute @cruiser.sunk?
    @cruiser.hit
    refute @cruiser.sunk?
    @cruiser.hit
    refute @cruiser.sunk?
    @cruiser.hit

    # It should be sunk now
    assert @cruiser.sunk?
  end

  def test_hit
    assert_equal 3, @cruiser.health
    @cruiser.hit
    assert_equal 2, @cruiser.health
  end

end
