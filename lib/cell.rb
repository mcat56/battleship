class Cell
  attr_reader :coordinate,
              :ship

  def initialize(coordinate, ship = nil)
    @coordinate  = coordinate
    @ship        = ship
    @fired_on    = false
  end

  def empty?
    @ship == nil
  end

  def ==(cell)
    if @coordinate == cell.coordinate
      true
    else
      false
    end
  end


  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_on
  end

  def fire_upon
    @fired_on = true
    if @ship != nil
      @ship.hit
    end
  end

  def render(render_ship=false)
    if @fired_on
      if empty?
        "M"
      else
        return "X" if @ship.sunk?
          "H"
      end
    else
      return "S" if (!empty? && render_ship)
        "."
    end
  end
end
