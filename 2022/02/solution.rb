class RockPaperScissorSolverPart1
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines.map { |line| Game.new(line) }
  end

  def calculate_score
    @data.sum { |game| game.score_round }
  end

  private

  class Game
    attr_accessor :opponent, :me

    def initialize(line)
      @opponent, @me = line.split(' ').map { |hand| translate_hand(hand) }
    end

    def score_round
      score = if @opponent == @me
                3
              else
                case @opponent
                when 'rock'
                  @me == 'paper' ? 6 : 0
                when 'paper'
                  @me == 'scissors' ? 6 : 0
                when 'scissors'
                  @me == 'rock' ? 6 : 0
                end
              end
      score + default_score
    end

    private

    DICTIONARY = {
      'A' => 'rock',
      'B' => 'paper',
      'C' => 'scissors',
      'X' => 'rock',
      'Y' => 'paper',
      'Z' => 'scissors',
    }.freeze

    DEFAULT_SCORE = {
      'rock' => 1,
      'paper' => 2,
      'scissors' => 3,
    }.freeze

    def translate_hand(hand)
      DICTIONARY[hand]
    end

    def default_score
      DEFAULT_SCORE[@me]
    end
  end
end

p RockPaperScissorSolverPart1.new('data.txt').calculate_score

class RockPaperScissorSolverPart2
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines.map { |line| Game.new(line) }
  end

  def calculate_score
    @data.sum { |game| game.score_round }
  end

  private

  class Game
    attr_accessor :opponent, :finish

    def initialize(line)
      @opponent, @finish = line.split(' ').map { |hand| translate_hand(hand) }
    end

    def score_round
      case @finish
      when 'draw'
        3 + default_score
      when 'lose'
        default_score
      when 'win'
        6 + default_score
      end
    end

    private

    DICTIONARY = {
      'A' => 'rock',
      'B' => 'paper',
      'C' => 'scissors',
      'X' => 'lose',
      'Y' => 'draw',
      'Z' => 'win',
    }.freeze

    DEFAULT_SCORE = {
      'rock' => 1,
      'paper' => 2,
      'scissors' => 3,
    }.freeze

    def translate_hand(hand)
      DICTIONARY[hand]
    end

    def default_score
      DEFAULT_SCORE[me]
    end

    def me
      return @opponent if should_draw?

      case @opponent
      when 'rock'
        should_win? ? 'paper' : 'scissors'
      when 'paper'
        should_win? ? 'scissors' : 'rock'
      when 'scissors'
        should_win? ? 'rock' : 'paper'
      end
    end

    def should_draw?
      @finish == 'draw'
    end

    def should_win?
      @finish == 'win'
    end
  end
end

p RockPaperScissorSolverPart2.new('data.txt').calculate_score
