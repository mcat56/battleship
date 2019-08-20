require './lib/ship'
require 'pry'

class Cell
attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def place_ship(ship)
    @ship = ship
  end

  def empty?
    @ship == nil
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @fired_upon = true
  end

  def render(display = nil)
    if empty? && @fired_upon == true
      "M"
    elsif !empty? && @fired_upon == true && @ship.sunk?
      "X"
    elsif !empty? && @fired_upon == false && display == true
      "S"
    elsif !empty? && @fired_upon == true
      "H"
    else
      "."
    end

 end

end
