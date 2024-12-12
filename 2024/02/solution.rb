class Solution
  def initialize(file_path)
    @reports = parse_reports(file_path)
  end

  def safe_reports_count
    @reports.select(&:valid?).count
  end

  def safe_reports_with_dampener_count
    @reports.select(&:valid_with_dampener?).count
  end

  private

  attr_reader :group_one, :group_two

  def parse_reports(file_path)
    parsed_reports = []

    File.open(file_path).readlines(chomp: true).each_with_index do |row, idx|
      parsed_reports << Report.new(id: idx, levels: row.split(' '))
    end

    parsed_reports
  end

  class Report
    attr_reader :levels

    MAX = 3
    MIN = 1

    def initialize(levels:, id:)
      @levels = levels.map(&:to_i)
    end

    def valid?
      mapped_increasing_booleans.all? || mapped_decreasing_booleans.all?
    end

    def valid_with_dampener?
      dampened_increasing_booleans.all? || dampened_decreasing_booleans.all?
    end

    private

    def dampened_increasing_booleans
      previous = nil
      already_skipped = false

      levels.map do |value|
        if previous.nil?
          previous = value
          true
        else
          if previous < value && difference_within_limit?((value - previous).abs)
            previous = value
            true
          elsif already_skipped == false
            already_skipped = true
            true
          else
            false
          end
        end
      end
    end

    def dampened_decreasing_booleans
      previous = nil
      already_skipped = false

      levels.map do |value|
        if previous.nil?
          previous = value
          true
        else
          if previous > value && difference_within_limit?((value - previous).abs)
            previous = value
            true
          elsif already_skipped == false
            already_skipped = true
            true
          else
            false
          end
        end
      end
    end

    def mapped_increasing_booleans
      previous = nil

      levels.map do |value|
        if previous.nil?
          previous = value
          true
        else
          if previous < value && difference_within_limit?((value - previous).abs)
            previous = value
            true
          else
            false
          end
        end
      end
    end

    def mapped_decreasing_booleans
      previous = nil

      levels.map do |value|
        if previous.nil?
          previous = value
          true
        else
          if previous > value && difference_within_limit?((value - previous).abs)
            previous = value
            true
          else
            false
          end
        end
      end
    end

    def difference_within_limit?(difference)
      difference <= MAX && difference >= MIN
    end
  end
end

solution = Solution.new('data.txt')
p solution.safe_reports_count
p solution.safe_reports_with_dampener_count
