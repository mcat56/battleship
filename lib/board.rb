class Board
attr_reader :cells

  def initialize(length=4, width=4)
    @cells  = {}
    @length = length
    @width  = width
  end

  def create_board(length, width)
    numeric_range = 1..length
    character_range = 1..width

    character_range.each do |w| 
      character_value = calculate_alphabetical_coordinate(w)
      character_range.each do |l|
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

  # def valid_coordinate?
  #   if cell.coordinate.chars.first =~ /^[ABCD/ && cell.coordinate.chars.last =~ /[1234]/
  #     true
  #   else
  #     false
  #   end
  # end

  # def valid_placement?(ship,coordinates)
  #   if ship.length == coordinates.length

  # end
end
