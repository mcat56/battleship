class Board
attr_reader :cells, :columns, :rows

  def initialize(columns=4, rows=4)
    @cells   = {}
    @columns = columns
    @rows    = rows
    create_board(@columns, @rows)
  end

  def create_board(columns, rows)
    numeric_range = 1..columns
    character_range = 1..rows

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
      divisible = (num % 26 == 0 ? 1 : 0)
      return calculate_alphabetical_coordinate(num / 26 - divisible) + calculate_alphabetical_coordinate(num % 26)
    end

  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end


  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
    end
  end

  def render(display = false)
    columns = 1..@columns
    rows    = 1..@rows

    number_string_length = @columns.to_s.length
    alphabetical_length  = calculate_alphabetical_coordinate(@rows).length
    padding              = [number_string_length, alphabetical_length].max

    # render top row
    row = " " * (padding + 1)
    columns.each { |col| row << "#{col}".center(padding + number_string_length) }

    row << "\n"

    # Render each row
    rows.each do |rw|
      letter = calculate_alphabetical_coordinate(rw)
      row << letter.center(padding + 1)
      columns.each do |col|
        coordinate = letter + col.to_s
        row << "#{@cells[coordinate].render(display)}".center(padding + number_string_length)
      end
      row << "\n"
    end
    row
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
    across_or_down?(coordinates)
  end

  def across_or_down?(coordinates)
    keys                    = @cells.keys
    coordinate_index        = keys.index(coordinates.first)
    valid_horizontal_coordinates = []
    valid_vertical_coordinates  = []

    # Determine if the correct coordinates would move to the next row
    # i.e. if the first coordinate is at the end of the row and the
    # ship length would extend over the right side of the  board,
    # then it cannot be placed
    coordinate_row        = coordinate_index / @columns
    next_row_index        = coordinate_row * @columns + @columns
    predicted_right_index = coordinate_index + coordinates.length
    if predicted_right_index <= next_row_index
      coordinates.length.times do |i|
        valid_horizontal_coordinates.push(keys[coordinate_index + i])
      end
    end

    # Determine if the correct coordinate would move outside the bounds of keys
    # i.e. if the ship would extend below the board, then the ship cannot
    # be placed
    needed_index = coordinate_index + ((coordinates.length - 1) * @columns)
    if needed_index < keys.length
      coordinates.length.times do |i|
        valid_vertical_coordinates.push(keys[coordinate_index + (@columns * i)])
      end
    end

    (valid_horizontal_coordinates == coordinates || valid_vertical_coordinates == coordinates)

    end


end
