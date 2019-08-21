class Board
attr_reader :cells

  def initialize(length=4, width=4)
    @cells  = cells
    @length = length
    @width  = width
  end

  def create_board(length, width)
    true
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
