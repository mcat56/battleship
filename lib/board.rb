class Board
attr_reader :cells

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

  end


  def valid_placement?(ship,coordinates)
    if ship.length == coordinates.length
      row = []
      column = []
      coordinates.each do |coordinate|
        row << coordinate.split("").first
        column << coordinate.split("").last
        if  ( [(coordinate.split("").last)..ship.width] == row && [(coorindate.split("").first)]*ship.length == column ) || ( [coordinate.split("").first] == row && ["A"]*ship.length == column )
