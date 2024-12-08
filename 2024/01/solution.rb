class Solution
  def initialize(file_path)
    @group_one, @group_two = split_data(file_path)
  end

  def distance_score
    distances.sum
  end

  def similarity_score
    score = 0
    @group_one.each do |value|
      score += value.to_i * @group_two.count(value)
    end
    score
  end

  private

  attr_reader :group_one, :group_two

  def distances
    distances = []

    sorted_group_one = group_one.sort
    sorted_group_two = group_two.sort

    sorted_group_one.each_with_index do |group_one_value, index|
      distances << (group_one_value.to_i - sorted_group_two[index].to_i).abs
    end

    distances
  end

  def split_data(file_path)
    array_one = []
    array_two = []

    File.open(file_path).readlines(chomp: true).each do |row|
      row_data = row.split(' ')
      array_one << row_data[0]
      array_two << row_data[1]
    end

    [array_one, array_two]
  end
end

solution = Solution.new('data.txt')
p solution.distance_score
p solution.similarity_score
# p Engine.new('data.txt').gears.map(&:matching_numbers).sum { |arr| arr[0].value * arr[1].value }
