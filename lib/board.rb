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
    zips = y.zip(x)
    coordinates = []
    zips.each do |array|
      coordinates << array.join
    end
    coordinates.each do |coordinate|
      @cells[coordinate] = Cell.new(coordinate)
    end
    @cells
  end

  def place(ship,coordinates)
    @cells.values.each do |cell|
      if cell.empty?
        coordinates.each do |coordinate|
          p @cells[coordinate]
          @cells[coordinate].place_ship(ship)
        end
      end
    end
  end

  def render
    x = (1..@width).to_a
    y = ("A"..("A".ord+@length).chr).to_a
    string = "  "
    x.each do |num|
      string << "#{num} "
    end
    y.each do |letter|
      string << "\n#{letter}" + " ." * y.length
    end
    string << " \n"
    puts string
  end


  def valid_placement?(ship,coordinates)
    if ship.length == coordinates.length
      row = []
      column = []
      coordinates.each do |coordinate|
        letter = coordinate.split("").first
        number = coordinate.split("").last
        row << number
        column << letter
        if  ( (number..(number+ship.width).to_a == row && [letter]*ship.length == column ) || ( [number]*ship.width == row && (letter..((letter.ord)+ship.length).chr)).to_a == column )
          true
        end
      end
    else
      false
    end
  end


end
