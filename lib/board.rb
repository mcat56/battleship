require 'pry'

class Board
attr_reader :cells, :length, :width

  def initialize(length = 4, width = 4)
    @cells = Hash.new
    @length = length
    @width =  width
    create_board(length, width)
  end

  def valid_coordinate?(coordinate)
    if coordinate.chars.first =~ /^[ABCD]/ && coordinate.chars.last =~ /[1234]/
      true
    else
      false
    end
  end

  def create_board(length,width)
    x = (1..@width).to_a
    y = ("A"..("A".ord+(@length-1)).chr).to_a
    coordinates = []
    y.each do |letter|
      x.each do |number|
        coordinates << letter + number.to_s
      end
    end
    coordinates.each do |coordinate|
      @cells[coordinate] = Cell.new(coordinate)
    end
    @cells
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
