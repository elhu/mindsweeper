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
    cells[y * width + x]
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
    valid_x = [x - 1, x, x + 1].freeze
    valid_y = [y - 1, y, y + 1].freeze
    valid_x.inject([]) do |origin, curr_x|
      if curr_x > 0 && curr_x < width
        valid_y.each do |curr_y|
          next if curr_y < 0 || curr_y >= height || (curr_x == x && curr_y == y)
          origin << [curr_x, curr_y]
        end
      end
      origin
    end
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
