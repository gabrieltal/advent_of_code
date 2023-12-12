class CalibrationCalculator
  def initialize(file_path)
    @file = File.open(file_path)
  end

  def calculate_sum
    collect_values.sum
  end

  def complex_sum
    collect_complex_values.sum
  end

  private

  attr_reader :file

  DICTIONARY = {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9,
  }.freeze

  def collect_values
    values = []
    file.readlines(chomp: true).each do |line|
      numeric_values = line.scan(/\d/)
      values << "#{numeric_values.first}#{numeric_values.last}".to_i
    end
    values
  end

  def collect_complex_values
    values = []

    file.readlines(chomp: true).each do |line|
      values << "#{find_earliest(line)}#{find_latest(line)}".to_i
    end
    values
  end

  def find_earliest(line)
    written_values = DICTIONARY.map { |k, v| [line.index(k), v] }.to_h.select { |k, v| !k.nil? }
    numeric_values = DICTIONARY.map { |_, v| [line.index(v.to_s), v] }.to_h.select { |k, v| !k.nil? }

    earliest_written = written_values.keys.sort.first
    earliest_numeric = numeric_values.keys.sort.first

    if earliest_written.nil?
      numeric_values[earliest_numeric]
    elsif earliest_numeric.nil?
      written_values[earliest_written]
    elsif earliest_written <= earliest_numeric
      written_values[earliest_written]
    else
      numeric_values[earliest_numeric]
    end
  end

  def find_latest(line)
    written_values = DICTIONARY.map { |k, v| [line.rindex(k), v] }.to_h.select { |k, v| !k.nil? }
    numeric_values = DICTIONARY.map { |_, v| [line.rindex(v.to_s), v] }.to_h.select { |k, v| !k.nil? }

    latest_written = written_values.keys.sort.last
    latest_numeric = numeric_values.keys.sort.last

    if latest_written.nil?
      numeric_values[latest_numeric]
    elsif latest_numeric.nil?
      written_values[latest_written]
    elsif latest_written >= latest_numeric
      written_values[latest_written]
    else
      numeric_values[latest_numeric]
    end
  end
end

p CalibrationCalculator.new('data.txt').calculate_sum
p CalibrationCalculator.new('data.txt').complex_sum
