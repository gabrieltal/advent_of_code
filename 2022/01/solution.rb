class CalorieIntake
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    collect_elf_calories_from_file!(file)
  end

  def find_most_calories
    find_elf_with_most(@data)[:total]
  end

  def find_top_three_most_calories
    data_set = @data.clone

    most = find_elf_with_most(data_set)
    data_set.delete(most[:elf])

    second = find_elf_with_most(data_set)
    data_set.delete(second[:elf])

    third = find_elf_with_most(data_set)

    most[:total] + second[:total] + third[:total]
  end

  private

  def find_elf_with_most(data_set)
    elf_with_mostest = nil
    high = nil

    data_set.each do |elf, calories|
      if high.nil? || calories.sum > high
        elf_with_mostest = elf
        high = calories.sum
      end
    end

    { elf: elf_with_mostest, total: high }
  end

  def collect_elf_calories_from_file!(file)
    index = 1
    @data = {}
    collected_calories = []

    file.readlines(chomp: true).each do |line|
      if line == ''
        @data[index] = collected_calories
        collected_calories = []
        index += 1
      else
        collected_calories << line.to_i
      end
    end

    @data[index] = collected_calories # add last line of file
  end
end

p CalorieIntake.new('data.txt').find_most_calories
p CalorieIntake.new('data.txt').find_top_three_most_calories
