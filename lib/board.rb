class Board
attr_reader :cells

  def initialize
    @cells = cells
  end


  def valid_coordinate?
    if cell.coordinate.chars.first =~ /^[ABCD/ && cell.coordinate.chars.last =~ /[1234]/
      true
    else
      false
    end
  end

  def valid_placement?(ship,coordinates)
    if ship.length == coordinates.length
  end 
