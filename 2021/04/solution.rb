class Bingo
  attr_accessor :data, :boards

  def initialize(data_file_path, boards_file_path)
    data_file = File.open(data_file_path)
    @data = data_file.readlines.map(&:to_i)

    boards_file = File.open(boards_file_path)

    current_board = Board.new
    @boards = []

    boards_file.readlines.each do |line|
      line.chomp!
      if line.empty?
        @boards << current_board
        current_board = Board.new
      else
        current_board.add_row(line)
      end
    end
  end

  def solution
    last_drawn = nil
    @data.each do |draw|
      break if winner?
      last_drawn = draw
      mark_boards!(draw)
      check_for_winner!
    end

    winner = @boards.find { |board| board.won? }
    last_drawn * winner.sum_of_unmarked
  end

  def solution_part_2
    last_solution = nil
    @data.each do |draw|
      mark_boards!(draw)
      check_for_winner!

      if winner?
        @boards.select(&:won?).each do |winner|
          last_solution = draw * winner.sum_of_unmarked
          @boards.delete(winner)
        end
      end
    end

    last_solution
  end

  private

  def winner?
    @boards.any?(&:won?)
  end

  def check_for_winner!
    @boards.each do |board|
      board.check_if_winner
    end
  end

  def mark_boards!(current)
    @boards.each do |board|
      board.mark_matches(current)
    end
  end
end

class Board
  attr_accessor :squares, :matches

  def initialize
    @squares = []
    @matches = false
  end

  def add_row(line)
    row = line.split(' ').map { |col| Square.new(col) }
    @squares << row
  end

  def mark_matches(current)
    @squares.each do |row|
      row.each do |item|
        item.mark! if item.val? current
      end
    end
  end

  def sum_of_unmarked
    sum = 0
    @squares.each do |row|
      row.each do |item|
        sum += item.value if item.unmarked?
      end
    end
    sum
  end

  def check_if_winner
    @squares.each do |row|
      if row.all?(&:marked?)
        @matches = true
        break
      end
    end

    @squares.transpose.each do |col|
      if col.all?(&:marked?)
        @matches = true
        break
      end
    end
  end

  def won?
    @matches
  end
end

class Square
  attr_accessor :value, :mark

  def initialize(value)
    @value = value.to_i
    @mark = false
  end

  def mark!
    @mark = true
  end

  def val?(val)
    @value == val
  end

  def marked?
    @mark
  end

  def unmarked?
    !@mark
  end
end

# Part 1
p Bingo.new('drawing.txt', 'boards.txt').solution

# Part 2
p Bingo.new('drawing.txt', 'boards.txt').solution_part_2
