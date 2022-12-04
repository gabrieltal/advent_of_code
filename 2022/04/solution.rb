class SectionAssignmentCompiler
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines(chomp: true).map { |line| Assignments.new(line) }
  end

  def count_any_overlaps
    @data.select(&:any_overlapping?).count
  end

  def count_full_inclusions
    @data.select(&:fully_includes_the_other?).count
  end

  private

  class Assignments
    attr_accessor :first, :second

    def initialize(line)
      sub1, sub2 = line.split(',')
      @first = sub1.split('-').map(&:to_i)
      @second = sub2.split('-').map(&:to_i)
    end

    def fully_includes_the_other?
      first_encompasses_the_second? || second_encompasses_the_first?
    end

    def any_overlapping?
      first_overlaps_second? || second_overlaps_first? || first_encompasses_the_second? || second_encompasses_the_first?
    end

    private

    def first_overlaps_second?
      @first.last >= @second.first && @first.first < @second.first
    end

    def second_overlaps_first?
      @second.last >= @first.first && @second.first < @first.first
    end

    def first_encompasses_the_second?
      if @first.first == @first.last
        @first.first >= @second.first && @first.last <= @second.last
      else
        @first.first <= @second.first && @first.last >= @second.last
      end
    end

    def second_encompasses_the_first?
      if @second.first == @second.last
        @first.first <= @second.first && @first.last >= @second.last
      else
        @first.first >= @second.first && @first.last <= @second.last
      end
    end
  end
end

p SectionAssignmentCompiler.new('data.txt').count_full_inclusions
p SectionAssignmentCompiler.new('data.txt').count_any_overlaps
