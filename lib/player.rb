class Player
attr_reader :name

  def initialize(name = "computer", is_human = false)
    @name = name
    @is_human = is_human
  end

  def human?
    @is_human
  end

end
