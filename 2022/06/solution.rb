class PacketFinder
  attr_accessor :data, :number_of_chars

  def initialize(file_path:, number_of_chars: 4)
    file = File.open(file_path)
    @number_of_chars = number_of_chars
    @data = file.readlines(chomp: true).first
  end

  def start_of_packet_index
    last_four = ''
    start_of_packet = nil

    @data.split('').each_with_index do |char, index|
      if last_four.length == @number_of_chars
        last_four = last_four[1...@number_of_chars] + char
      else
        last_four += char
        next
      end

      if last_four.chars.uniq == last_four.chars
        start_of_packet = index + 1
        break
      end
    end

    start_of_packet
  end
end

p PacketFinder.new(file_path: 'data.txt').start_of_packet_index
p PacketFinder.new(file_path: 'data.txt', number_of_chars: 14).start_of_packet_index
