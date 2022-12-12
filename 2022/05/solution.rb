class SupplyStacksSolver
  attr_accessor :board, :moves

  def initialize(file_path)
    @parser = Parser.new(File.open(file_path))
    @board = @parser.setup_board
    @moves = @parser.setup_moves
  end

  def make_moves!
    @moves.each do |number_to_move:, from:, to:|
      number_to_move.times do |t|
        @board[to].unshift(@board[from].shift)
      end
    end
  end

  def make_9001_moves!
    @moves.each do |number_to_move:, from:, to:|
      if number_to_move > 1
        pieces_to_move = []

        number_to_move.times do |t|
          pieces_to_move.unshift(@board[from].shift)
        end

        pieces_to_move.each do |piece|
          @board[to].unshift(piece)
        end
      else
        @board[to].unshift(@board[from].shift)
      end
    end
  end

  def top_of_stack
    @board.map { |_, arr| arr[0] }.join
  end

  private

  attr_reader :parser

  class Parser
    def initialize(file)
      @raw_crates = []
      @raw_counts = nil
      @raw_movesets = []

      file.readlines(chomp: true).each do |line|
        if line[0..3] == 'move'
          @raw_movesets << line
        elsif line == ''
          # no-op
        elsif line.split(' ')[0] == '1'
          @raw_counts = line
        else
          @raw_crates << line
        end
      end
    end

    def setup_board
      board = {}

      @raw_counts.split(' ').each do |counter|
        board[counter.to_i] = []
      end

      @raw_crates.each do |crate_row|
        index = 1
        board.each do |counter, arr|
          arr << crate_row[index] if crate_row[index] != nil && crate_row[index] != ' '
          index += 4
        end
      end

      board
    end

    def setup_moves
      @raw_movesets.map do |raw_set|
        only_numbers = raw_set.split(' ').select { |word| word.to_i > 0 }
        {
          number_to_move: only_numbers[0].to_i,
          from: only_numbers[1].to_i,
          to: only_numbers[2].to_i,
        }
      end
    end

    private

    attr_reader :raw_crates, :raw_counts, :raw_movesets
  end
end

sss = SupplyStacksSolver.new('data.txt')
sss.make_moves!
p sss.top_of_stack

sss9001 = SupplyStacksSolver.new('data.txt')
sss9001.make_9001_moves!
p sss9001.top_of_stack
