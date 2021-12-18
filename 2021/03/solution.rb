class DiagnosticReport
  attr_accessor :data, :gamma_rate, :epsilon_rate

  def initialize(file_path)
    file = File.open(file_path)
    @gamma_rate = ''
    @epsilon_rate = ''
    @data = file.readlines(chomp: true)
    calculate_rates
  end

  def power_consumption
    epsilon_rate.to_i(2) * gamma_rate.to_i(2)
  end

  private

  def calculate_rates
    occurrences.each do |_idx, value|
      if value['1'] > value['0']
        @gamma_rate += '1'
        @epsilon_rate += '0'
      else
        @gamma_rate += '0'
        @epsilon_rate += '1'
      end
    end
  end

  def occurrences
    calculations = {}
    data.each do |line|
      line.split('').each_with_index do |char, idx|
        calculations[idx] = { '1' => 0, '0' => 0 } if calculations[idx].nil?
        calculations[idx][char] += 1
      end
    end
    calculations
  end
end

# Part 1
p DiagnosticReport.new('data.txt').power_consumption

# Part 2
# p DiagnosticReport.new('data.txt').
