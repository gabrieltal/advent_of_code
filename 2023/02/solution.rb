class CubeConundrum
  attr_reader :games

  def initialize(file_path)
    @file = File.open(file_path)
    @games = []
    file.readlines(chomp: true).each do |row|
      @games << parse_row(row)
    end
  end

  private

  attr_reader :file

  def parse_row(row)
    game, raw_sets = row.split(':')
    id = game.delete("Game ").to_i
    sets = raw_sets.split(";").map { |set| Set.new(set.strip) }
    Game.new(id, sets)
  end

  class Game
    attr_reader :id, :sets

    def initialize(id, sets)
      @id = id
      @sets = sets
    end

    def possible?(red:, green:, blue:)
      @sets.all? { |set| set.red <= red && set.green <= green && set.blue <= blue }
    end

    def smallest_set
      max_red = 0
      max_green = 0
      max_blue = 0

      @sets.each do |set|
        if set.red > max_red
          max_red = set.red
        end

        if set.green > max_green
          max_green = set.green
        end

        if set.blue > max_blue
          max_blue = set.blue
        end
      end

      Set.initialize_from_actual(red: max_red, green: max_green, blue: max_blue)
    end
  end

  class Set
    attr_reader :red, :blue, :green

    def initialize(data)
      @red = 0
      @blue = 0
      @green = 0

      data.split(', ').each do |draw|
        if draw.include?("red")
          @red = draw.delete(" red").to_i
        elsif draw.include?("blue")
          @blue = draw.delete(" blue").to_i
        elsif draw.include?("green")
          @green = draw.delete(" green").to_i
        else
          raise "unmapped #{draw}"
        end
      end
    end

    def self.initialize_from_actual(red:, green:, blue:)
      new("#{red} red, #{green} green, #{blue} blue")
    end

    def sum
      red + blue + green
    end

    def power
      red * blue * green
    end
  end
end

games = CubeConundrum.new('data.txt').games
possible_games = games.select { |game| game.possible?(red: 12, green: 13, blue: 14) }
p possible_games.sum(&:id)

games = CubeConundrum.new('data.txt').games
smallest_sets = games.map { |game| game.smallest_set }
p smallest_sets.sum(&:power)
