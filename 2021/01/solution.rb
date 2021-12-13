class CalculateDepthIncrease
  SLIDING_WINDOW = 2
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines.map(&:to_i)
  end

  def increments_with_sliding_window
    prev = nil
    number_times_increased = 0
    sliding_window_sum = nil

    data.each_with_index do |depth, index|
      current_sum = sliding_window_sum_at_depth(index)

      if prev.nil?
        number_times_increased += 1
      else
        next if (index + SLIDING_WINDOW) >= data.length - 1
        if current_sum > prev
          number_times_increased += 1
        end
      end
      prev = current_sum
    end

    number_times_increased
  end

  def increments_at_each_depth
    prev = nil
    number_times_increased = 0

    data.each do |depth|
      if prev.nil?
        number_times_increased += 1
      elsif depth > prev
        number_times_increased += 1
      end

      prev = depth
    end

    number_times_increased
  end

  private

  def sliding_window_sum_at_depth(start_index)
    data[start_index..start_index + SLIDING_WINDOW].sum
  end
end

# Part 1
p CalculateDepthIncrease.new('data.txt').increments_at_each_depth

# Part 2
p CalculateDepthIncrease.new('data.txt').increments_with_sliding_window
