class Turn
  attr_reader :coordinate, :attacker_data, :defender_data

  def initialize(coordinate, attacker_data, defender_data)
    @coordinate = coordinate
    @attacker_data = attacker_data
    @defender_data = defender_data
  end

end 
