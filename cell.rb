class Cell
  attr_reader :mine
  attr_accessor :neighbouring_mines

  def initialize
    @mine = false
  end

  def set_mine!
    @mine = true
  end

  def to_s
    neighbouring_mines || '-'
  end

end
