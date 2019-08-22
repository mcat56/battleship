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
    if valid_placement?
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
      if display == false
        y.each do |letter|
          string << "\n#{letter}" + " ." * y.length + " "
        end
        string << "\n"
      else
        render_true = []
        @cells.each_value do |value|
          render_true << value.render(true)
        end
        i = 0
        y.each do |letter|
          string << "\n#{letter} "
          y.length.times do
            string << "#{render_true[i]} "
            i += 1
          end
        end
        string << "\n"
      end
  end


  def valid_placement?(ship,coordinates)
    if ship.length != coordinates.length
       return false
    end
    if coordinates.any? do |coordinate|
      valid_coordinate?(coordinate) == false || @cells[coordinate].empty? == false
      end
      return false
    end
    keys = @cells.keys
    x = keys.index(coordinates.first)
    right = keys[x+1]
    next_row = keys[x+@width]
      if coordinates[1] == right

      elsif coordinates[1] == next_row
        hash_indices = []
        coordinates.each do |coordinate|
          hash_indices << keys.index(coordinate)
        end
        i = 0
        hash_indices.each do |index|
          if hash_indices[i+1]-hash_indices[i] != @width
            return false
          i += 1
          end
        end
      else
        false
    end
  end




end
