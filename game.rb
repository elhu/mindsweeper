class Game
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def start_game
    puts board.to_s
    while true do
      x, y = STDIN.gets.chomp.split(" ").map(&:to_i)
      cell = board.cell_at(x, y)
      if cell.mine
        puts "You lose, sorry!"
        break
      else
        if cell.neighbouring_mines.nil?
          if (cell.neighbouring_mines = board.neighbouring_mines_count(x, y)) == 0
            board.discover_area(x, y)
          end
        end
      end
      puts board.to_s
      puts ""
    end
  end

end
