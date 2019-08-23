class Player
attr_reader :cruiser, :submarine

  def initialize
    @cruiser = Ship.new("Cruiser",3)
    @submarine = Ship.new("Submarine", 2)
  end




end
