class Board
attr_reader :cells,
            :columns,
            :rows

  def initialize(columns=4, rows=4)
    @cells   = {}
    @columns = columns
    @rows    = rows
    create_board(@columns, @rows)
  end

  def ==(board)
    @cells.keys == board.cells.keys
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
      "Z"
    elsif num <= 26
      (num + 64).chr
    else
      divisible = (num % 26 == 0 ? 1 : 0)
      calculate_alphabetical_coordinate(num / 26 - divisible) + calculate_alphabetical_coordinate(num % 26)
    end
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each { |coordinate| @cells[coordinate].place_ship(ship) }
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
      row << construct_row_render(rw, columns, padding, display)
      row << "\n"
    end
    row
  end

  def construct_row_render(row_number, columns, padding, display)
    row = ""
    number_string_length = @columns.to_s.length
    letter = calculate_alphabetical_coordinate(row_number)
      row << letter.center(padding + 1)
      columns.each do |col|
        coordinate = letter + col.to_s
        row << "#{@cells[coordinate].render(display)}".center(padding + number_string_length)
      end
    row
  end


  def valid_placement?(ship, coordinates)
    return false if !same_length?(ship, coordinates)
    return false if !all_valid_coordinates?(coordinates)
    return false if !all_empty?(coordinates)
    across_or_down?(coordinates)
  end

  def across_or_down?(coordinates)
    valid_coordinates = generate_valid_coordinates(coordinates, coordinates.length)

    (valid_coordinates.first == coordinates || valid_coordinates.last == coordinates)
  end

  def generate_valid_coordinates(coordinates, length)
    valid_horizontal_coordinates = generate_horizontal_coordinates(coordinates, length)
    valid_vertical_coordinates   = generate_vertical_coordinates(coordinates, length)
    valid_coordinates            = []

    valid_coordinates << valid_horizontal_coordinates << valid_vertical_coordinates
  end

  def generate_horizontal_coordinates(coordinates, length)
    horizontal_coordinates = []
    keys                   = @cells.keys
    coordinate_index       = keys.index(coordinates.first)
    coordinate_row         = coordinate_index / @columns
    next_row_index         = coordinate_row * @columns + @columns
    predicted_right_index  = coordinate_index + length

    if predicted_right_index <= next_row_index
      length.times do |i|
        horizontal_coordinates.push(keys[coordinate_index + i])
      end
    end

    horizontal_coordinates
  end

  def generate_vertical_coordinates(coordinates, length)
    vertical_coordinates = []
    keys                 = @cells.keys
    coordinate_index     = keys.index(coordinates.first)
    needed_index         = coordinate_index + ((length - 1) * @columns)

    if needed_index < keys.length
      length.times do |i|
        vertical_coordinates.push(keys[coordinate_index + (@columns * i)])
      end
    end

    vertical_coordinates
  end

  def same_length?(ship, coordinates)
    ship.length == coordinates.length
  end

  def all_valid_coordinates?(coordinates)
    coordinates.all? { |coordinate| valid_coordinate?(coordinate) }
  end

  def all_empty?(coordinates)
    coordinates.all? { |coordinate| @cells[coordinate].empty? }
  end

end
