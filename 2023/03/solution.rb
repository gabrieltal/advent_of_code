class Engine
  attr_reader :data, :numbers, :anamolies

  def initialize(file_path)
    @file = File.open(file_path)
    @data = []
    @numbers = []
    @anamolies = []

    file.readlines(chomp: true).each_with_index do |row, row_idx|
      row_data = row.split('')
      data << row_data

      temp_number = ''
      row_data.each_with_index do |str, idx|
        if str.match?(/\d/)
          temp_number += str
          numbers << Number.new(temp_number, row_idx, idx) if (idx + 1) == row_data.length
        elsif temp_number != ''
          numbers << Number.new(temp_number, row_idx, idx - 1)
          temp_number = ''
        end

        anamolies << Anamoly.new(str, row_idx, idx) if str != '.'
      end
    end
  end

  def schematic_numbers
    numbers.select { |number| number.near_anamoly?(anamolies) }
  end

  def gear_numbers
    numbers.select { |number| number.near_anamoly?(anamoly_gears) }
  end

  def anamoly_gears
    @anamoly_gears ||= anamolies.select { |moly| moly.value == '*' }
  end

  def gears
    anamoly_gears.select { |moly| moly.has_two_gear_numbers_near?(gear_numbers) }
  end

  private

  attr_reader :file

  class Number
    attr_reader :value, :row_index, :column_indices

    def initialize(value, row_index, last_index)
      @value = value.to_i
      @row_index = row_index
      @column_indices = Array((last_index - (value.length - 1)) .. last_index)
    end

    def near_anamoly?(anamolies)
      anamoly_coordinates = anamolies.map(&:coordinates)
      !(surrounding_coodinates & anamoly_coordinates).empty?
    end

    def surrounding_coodinates
      coordinates = []

      coordinates << [row_index - 1, column_indices[0] - 1]
      column_indices.each do |col|
        coordinates << [row_index - 1, col]
      end
      coordinates << [row_index - 1, column_indices[-1] + 1]

      coordinates << [row_index, column_indices[0] - 1]
      coordinates << [row_index, column_indices[-1] + 1]

      coordinates << [row_index + 1, column_indices[0] - 1]
      column_indices.each do |col|
        coordinates << [row_index + 1, col]
      end
      coordinates << [row_index + 1, column_indices[-1] + 1]

      coordinates
    end
  end

  class Anamoly
    attr_reader :value, :row, :column, :matching_numbers

    def initialize(value, row, column)
      @value = value
      @row = row
      @column = column
    end

    def coordinates
      [row, column]
    end

    def has_two_gear_numbers_near?(schematic_numbers)
      @matching_numbers ||= find_schematic_gears(schematic_numbers)
      matching_numbers.count == 2
    end

    private

    def find_schematic_gears(schematic_numbers)
      schematic_numbers.select { |numb| numb.near_anamoly?([self]) }
    end
  end
end

p Engine.new('data.txt').schematic_numbers.sum(&:value)
p Engine.new('data.txt').gears.map(&:matching_numbers).sum { |arr| arr[0].value * arr[1].value }
