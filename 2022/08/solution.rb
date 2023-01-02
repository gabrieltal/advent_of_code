class TreeParser
  attr_accessor :data

  def initialize(file_path)
    @data = parse_file!(File.open(file_path))
  end

  def trees_visible
    visible_count = 0

    @data.each do |row_idx, arr|
      arr.each_with_index do |value, col_idx|
        coordinates = {
          value: value,
          col_idx: col_idx,
          row_idx: row_idx,
        }

        if edge_value?(row_idx, col_idx)
          visible_count += 1
        elsif visibility_up?(coordinates) || visibility_down?(coordinates) || visibility_left?(coordinates) || visibility_right?(coordinates)
          visible_count += 1
        end
      end
    end

    visible_count
  end

  def find_highest_scenic_score
    highest_score = 0

    @data.each do |row_idx, arr|
      arr.each_with_index do |value, col_idx|
        coordinates = {
          value: value,
          col_idx: col_idx,
          row_idx: row_idx,
        }
        score = viewing_dist(dir: :up, **coordinates) *
          viewing_dist(dir: :down, **coordinates) *
          viewing_dist(dir: :left, **coordinates) *
          viewing_dist(dir: :right, **coordinates)
        highest_score = score if highest_score < score
      end
    end

    highest_score
  end

  private

  def viewing_dist(dir:, value:, col_idx:, row_idx:)
    if dir == :up
      count_visibilty(dir: :up, value: value, col_idx: col_idx, row_idx: row_idx)
    elsif dir == :down
      count_visibilty(dir: :down, value: value, col_idx: col_idx, row_idx: row_idx)
    elsif dir == :left
      count_visibilty(dir: :left, value: value, col_idx: col_idx, row_idx: row_idx)
    elsif dir == :right
      count_visibilty(dir: :right, value: value, col_idx: col_idx, row_idx: row_idx)
    else
      raise 'wuht'
    end
  end

  def parse_file!(file)
    hash = {}
    file.readlines(chomp: true).each_with_index do |line, index|
      hash[index] = line.split('')
    end
    hash
  end

  def max_index
    @data.keys.length - 1
  end

  def edge_value?(row_idx, col_idx)
    col_idx == 0 ||
      row_idx == 0 ||
      row_idx == (max_index) ||
      col_idx == (max_index)
  end

  def count_visibilty(dir:, value:, col_idx:, row_idx:)
    counter = 0
    keep_counting = true

    if dir == :up
      (row_idx - 1).downto(0) do |index|
        counter += 1 if keep_counting
        keep_counting = false if @data[index][col_idx] >= value
      end
    elsif dir == :down
      (row_idx + 1).upto(max_index) do |index|
        counter += 1 if keep_counting
        keep_counting = false if @data[index][col_idx] >= value
      end
    elsif dir == :left
      (col_idx - 1).downto(0) do |index|
        counter += 1 if keep_counting
        keep_counting = false if @data[row_idx][index] >= value
      end
    elsif dir == :right
      (col_idx + 1).upto(max_index) do |index|
        counter += 1 if keep_counting
        keep_counting = false if @data[row_idx][index] >= value
      end
    end

    counter
  end

  def visibility_up?(value:, col_idx:, row_idx:)
    is_visible = true

    (col_idx - 1).downto(0) do |index|
      if @data[row_idx][index] >= value
        is_visible = false
      end
    end

    is_visible
  end

  def visibility_down?(value:, col_idx:, row_idx:)
    is_visible = true

    (col_idx + 1).upto(max_index) do |index|
      if @data[row_idx][index] >= value
        is_visible = false
      end
    end

    is_visible
  end

  def visibility_left?(value:, col_idx:, row_idx:)
    is_visible = true

    (row_idx - 1).downto(0) do |index|
      if @data[index][col_idx] >= value
        is_visible = false
      end
    end

    is_visible
  end

  def visibility_right?(value:, col_idx:, row_idx:)
    is_visible = true

    (row_idx + 1).upto(max_index) do |index|
      if @data[index][col_idx] >= value
        is_visible = false
      end
    end

    is_visible
  end
end

p TreeParser.new('data.txt').trees_visible
p TreeParser.new('data.txt').find_highest_scenic_score
