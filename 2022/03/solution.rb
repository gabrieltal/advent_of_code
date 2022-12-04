class RucksackPriotization
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines(chomp: true).map { |line| Rucksack.new(line) }
  end

  def summarize
    shared_letters = @data.map { |rucksack| rucksack.find_shared_letters }.flatten
    shared_letters.map { |letter| SCORE_LETTER[letter] }.sum
  end

  private

  SCORE_LETTER = {
    'a' => 1,
    'b' => 2,
    'c' => 3,
    'd' => 4,
    'e' => 5,
    'f' => 6,
    'g' => 7,
    'h' => 8,
    'i' => 9,
    'j' => 10,
    'k' => 11,
    'l' => 12,
    'm' => 13,
    'n' => 14,
    'o' => 15,
    'p' => 16,
    'q' => 17,
    'r' => 18,
    's' => 19,
    't' => 20,
    'u' => 21,
    'v' => 22,
    'w' => 23,
    'x' => 24,
    'y' => 25,
    'z' => 26,
    'A' => 27,
    'B' => 28,
    'C' => 29,
    'D' => 30,
    'E' => 31,
    'F' => 32,
    'G' => 33,
    'H' => 34,
    'I' => 35,
    'J' => 36,
    'K' => 37,
    'L' => 38,
    'M' => 39,
    'N' => 40,
    'O' => 41,
    'P' => 42,
    'Q' => 43,
    'R' => 44,
    'S' => 45,
    'T' => 46,
    'U' => 47,
    'V' => 48,
    'W' => 49,
    'X' => 50,
    'Y' => 51,
    'Z' => 52,
  }.freeze

  class Rucksack
    attr_accessor :first_compartment, :second_compartment

    def initialize(line)
      length = line.length
      @first_compartment = line[0, length / 2]
      @second_compartment =line[length / 2, length]
    end

    def find_shared_letters
      hash = Hash.new(0)
      @first_compartment.split('').each { |letter| hash[letter] += 1 if @second_compartment.include?(letter) }
      hash.select { |k, v| v > 0 }.keys
    end
  end
end

p RucksackPriotization.new('data.txt').summarize

class RucksackPriotizationPart2
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines(chomp: true)
  end

  def summarize
    sum = 0

    @data.each_slice(3) do |chunk|
      badge_letter = find_badge_letter_in_chunk(chunk)
      sum += SCORE_LETTER[badge_letter]
    end

    sum
  end

  private

  def find_badge_letter_in_chunk(chunk)
    chunk[0].split('').find do |letter|
      chunk[1].include?(letter) && chunk[2].include?(letter)
    end
  end

  SCORE_LETTER = {
    'a' => 1,
    'b' => 2,
    'c' => 3,
    'd' => 4,
    'e' => 5,
    'f' => 6,
    'g' => 7,
    'h' => 8,
    'i' => 9,
    'j' => 10,
    'k' => 11,
    'l' => 12,
    'm' => 13,
    'n' => 14,
    'o' => 15,
    'p' => 16,
    'q' => 17,
    'r' => 18,
    's' => 19,
    't' => 20,
    'u' => 21,
    'v' => 22,
    'w' => 23,
    'x' => 24,
    'y' => 25,
    'z' => 26,
    'A' => 27,
    'B' => 28,
    'C' => 29,
    'D' => 30,
    'E' => 31,
    'F' => 32,
    'G' => 33,
    'H' => 34,
    'I' => 35,
    'J' => 36,
    'K' => 37,
    'L' => 38,
    'M' => 39,
    'N' => 40,
    'O' => 41,
    'P' => 42,
    'Q' => 43,
    'R' => 44,
    'S' => 45,
    'T' => 46,
    'U' => 47,
    'V' => 48,
    'W' => 49,
    'X' => 50,
    'Y' => 51,
    'Z' => 52,
  }.freeze
end

p RucksackPriotizationPart2.new('data.txt').summarize
