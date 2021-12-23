class DiagnosticReport
  attr_accessor :data

  def initialize(file_path)
    file = File.open(file_path)
    @data = file.readlines(chomp: true)
  end

  def power_consumption
    gamma_rate = ''
    epsilon_rate = ''
    occurrences.each do |_idx, value|
      if value['1'] > value['0']
        gamma_rate += '1'
        epsilon_rate += '0'
      else
        gamma_rate += '0'
        epsilon_rate += '1'
      end
    end
    epsilon_rate.to_i(2) * gamma_rate.to_i(2)
  end

  def life_support_ratings
    oxy_gen_rating_bits = @data
    co2_scrub_bits = @data

    0.upto(@data.length - 1).each do |index|
      next if oxy_gen_rating_bits.length == 1

      oxy_items_to_remove = []
      co2_items_to_remove = []

      oxy_occurrences = occurrences(oxy_gen_rating_bits)
      co2_occurrences = occurrences(co2_scrub_bits)

      if oxy_occurrences[index]['1'] > oxy_occurrences[index]['0']
        oxy_gen_rating_bits.each do |line|
          oxy_items_to_remove << line if line[index] == '0' && oxy_gen_rating_bits.count != 1
        end
      elsif oxy_occurrences[index]['1'] < oxy_occurrences[index]['0']
        oxy_gen_rating_bits.each do |line|
          oxy_items_to_remove << line if line[index] == '1' && oxy_gen_rating_bits.count != 1
        end
      else
        oxy_gen_rating_bits.each do |line|
          oxy_items_to_remove << line if line[index] == '0' && oxy_gen_rating_bits.count != 1
        end
      end

      if co2_occurrences[index]['1'] > co2_occurrences[index]['0']
        co2_scrub_bits.each do |line|
          co2_items_to_remove << line if line[index] == '1' && co2_scrub_bits.count != 1
        end
      elsif co2_occurrences[index]['1'] < co2_occurrences[index]['0']
        co2_scrub_bits.each do |line|
          co2_items_to_remove << line if line[index] == '0' && co2_scrub_bits.count != 1
        end
      else
        co2_scrub_bits.each do |line|
          co2_items_to_remove << line if line[index] == '1' && co2_scrub_bits.count != 1
        end
      end

      oxy_gen_rating_bits -= oxy_items_to_remove
      co2_scrub_bits -= co2_items_to_remove
    end

    oxy_gen_rating_bits.first.to_i(2) * co2_scrub_bits.first.to_i(2)
  end

  private

  def occurrences(data = @data)
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
p DiagnosticReport.new('data.txt').life_support_ratings
