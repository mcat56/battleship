require 'pry'

class Board
attr_reader :cells, :length, :width

  def initialize(length=4, width=4)
    @cells = {}
    @length = length
    @width  = width
    create_board(@length, @width)
  end

  def create_board(length, width)
    numeric_range = 1..length
    character_range = 1..width

    character_range.each do |w| 
      character_value = calculate_alphabetical_coordinate(w)
      numeric_range.each do |l|
        coordinate = character_value + l.to_s
        new_cell = Cell.new(coordinate)
        @cells[new_cell.coordinate] = new_cell
      end
    end
  end

  def calculate_alphabetical_coordinate(num)
    if num == 0
      return "Z"
    elsif num <= 26
      return (num + 64).chr
    else
      divisible = 0
      if num % 26 == 0
        divisible = 1
      end
      return calculate_alphabetical_coordinate(num / 26 - divisible) + calculate_alphabetical_coordinate(num % 26)
    end

  end

  def valid_coordinate?(coordinate)
   @cells.has_key?(coordinate)
  end

  def place(ship,coordinates)
    valid = []
    coordinates.each do |coordinate|
      valid << @cells[coordinate].empty?
    end
      if valid.include?(false)
        return
      else
        coordinates.each do |coordinate|
          @cells[coordinate].place_ship(ship)
        end
      end
  end

  def render(display=false)
    x = (1..@width).to_a
    y = ("A"..("A".ord+(@length-1)).chr).to_a
    string = "  "
    x.each do |num|
      string << "#{num} "
    end
    y.each do |letter|
      string << "\n#{letter}" + " ." * y.length + " "
    end
    string << "\n"
  end


  def valid_placement?(ship,coordinates)
    # if ship.length != coordinates.length
    #   return false
    # end
    # if coordinates.any? { |coordinate| @cells[coordinate].empty? }
    #   return false
    # end
    if ship.length == coordinates.length
      length = ship.length - 1
      row = []
      column = []
      coordinates.each do |coordinate|
        letter = coordinate.split("").first
        number = coordinate.split("").last.to_i
        row << number
        column << letter
      end
      letter = coordinates[0].split("").first
      number = coordinates[0].split("").last.to_i
      limit = number + length
      last = (letter.ord + length).chr
        if (  ((number..limit).to_a == row) && ([letter]*length == column)  )  || (   (([number]*length) == row)    &&    ((letter..last).to_a == column)   )
          true
        else
          false
        end
    end
  end
end
