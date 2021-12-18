class CalculateDepthIncrease
  attr_accessor :data, :depth, :breadth

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines.map do |line|
      direction, amount = line.split(' ')
      {
        direction: direction,
        amount: amount.to_i
      }
    end
  end


  def total_depth
    breadth = 0
    depth = 0

    data.each do |obj|
      direction = obj[:direction]
      amount = obj[:amount]

      if direction == 'forward'
        breadth += amount
      elsif direction == 'down'
        depth += amount
      elsif direction == 'up'
        depth -= amount
      else
        raise "Issue parsing #{direction}"
      end
    end

    breadth * depth
  end

  def depth_by_aim
    breadth = 0
    depth = 0
    aim = 0

    data.each do |obj|
      direction = obj[:direction]
      amount = obj[:amount]

      if direction == 'forward'
        breadth += amount
        depth += (aim * amount)
      elsif direction == 'down'
        aim += amount
      elsif direction == 'up'
        aim -= amount
      else
        raise "Issue parsing #{direction}"
      end
    end

    breadth * depth
  end
end

# Part 1
p CalculateDepthIncrease.new('data.txt').total_depth

# Part 2
p CalculateDepthIncrease.new('data.txt').depth_by_aim
