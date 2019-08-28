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

  def test_has_attributes
    assert_equal "Cruiser", @cruiser.name
    assert_equal 3, @cruiser.length
    assert_equal 3, @cruiser.health
  end

  def test_health_gets_reduced_when_hit
    @cruiser.hit
    @cruiser.hit
    assert_equal 1, @cruiser.health
    
  end

  def test_equality
    cruiser = Ship.new("Cruiser", 3)
    assert_equal true, @cruiser.eql?(cruiser)

    submarine = Ship.new("Submarine", 2)
    assert_equal false, @cruiser.eql?(submarine)
  end

  def test_is_not_sunk
    assert_equal false, @cruiser.sunk?
  end

  def test_ship_gets_sunk
    @cruiser.hit
    @cruiser.hit
    assert_equal false, @cruiser.sunk?
    @cruiser.hit

    assert_equal true, @cruiser.sunk?
  end

end
