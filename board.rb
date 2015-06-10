require_relative 'cell'

class Board
  attr_reader :width, :height, :mines, :cells

  def initialize(width:, height:, mines:)
    @width = width
    @height = height
    @mines = mines

    init_cells
    place_mines
  end

  def cell_at(x, y)
    cells[x * width + y]
  end

  def discover_area(x, y)
    neighbours_for(x, y).each do |coords|
      cell = cell_at(*coords)
      if cell.neighbouring_mines == nil
        if (cell.neighbouring_mines = neighbouring_mines_count(*coords)) == 0
          discover_area(*coords)
        end
      end
    end
  end

  def neighbouring_mines_count(x, y)
    neighbours_for(x, y).count { |coords| cell_at(*coords).mine }
  end

  def neighbours_for(x, y)
    neighbours = []
    if x > 0
      neighbours << [x - 1, y]
    end
    if x < height - 1
      neighbours << [x + 1, y]
    end
    if y > 0
      neighbours << [x, y - 1]
    end
    if y < width - 1
      neighbours << [x, y + 1]
    end
    neighbours
  end

  def to_s
    cells.each_slice(width).map do |line|
      line.map(&:to_s).join('')
    end.join("\n")
  end

  private
  def init_cells
    @cells = []
    0.upto(width * height - 1) do |n|
      @cells << Cell.new
    end
  end

  def place_mines
    0.upto(mines - 1) do |n|
      cells[n].set_mine!
    end
    cells.shuffle!
  end

end
