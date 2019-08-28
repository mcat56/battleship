class Cell
  attr_reader :coordinate,
              :ship

  def initialize(coordinate)
    @coordinate  = coordinate
    @ship        = nil
    @fired_on    = false
  end

  def ==(cell)
    @coordinate == cell.coordinate
  end

  def empty?
    @ship == nil
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_on
  end

  def fire_upon
    @fired_on = true
    @ship.hit if @ship != nil
  end

  def render(render_ship=false)
    if fired_upon?
      if empty?
        "M"
      else
        @ship.sunk? ? "X" : "H"
      end
    else
      (!empty? && render_ship) ? "S" : '.'
    end
  end
end
