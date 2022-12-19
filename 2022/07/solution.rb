class CommandLineReader
  attr_accessor :console_input, :file_tree, :current_dir, :current_line_index

  def initialize(file_path)
    file = File.open(file_path)
    @console_input = file.readlines(chomp: true)
    @file_tree = FileTree.new
    @current_line_index = 0
    @current_dir = nil
    parse_commands!
  end

  def sum_of_dirs_under_100k
    @file_tree.directories_under.map(&:size).sum
  end

  def smallest_directory_to_delete_to_free_enough_space
    @file_tree.directories_over(size: free_space_needed).min { |a, b| a <=> b }
  end

  def free_space_needed
    max_space = 70000000
    p "fsn #{max_space - @file_tree.root.size}"
    max_space - @file_tree.root.size
  end

  private

  def parse_commands!
    readline!
  end

  def readline!
    return if @current_line_index > @console_input.length

    if current_line == '$ cd /'
      @file_tree.root = Directory.new(name: '/')
      @current_dir = @file_tree.root
      increment_index!
      readline!
    elsif current_line == '$ ls'
      read_directory_content!
    elsif current_line == '$ cd ..'
      @current_dir = @current_dir.parent
      increment_index!
      readline!
    elsif current_line[0..3] == '$ cd'
      @current_dir = @current_dir.find_directory(current_line.split(' ').last)
      increment_index!
      readline!
    else
      raise 'unexpected input'
    end
  end

  def read_directory_content!
    increment_index!

    if current_line == nil
      nil
    elsif current_line[0] == '$'
      readline!
    else
      signal, name = current_line.split(' ')
      if signal == 'dir'
        @current_dir.children << Directory.new(name: name, parent: @current_dir)
      else
        @current_dir.children << ComputerFile.new(size: signal, name: name, parent: @current_dir)
      end
      read_directory_content!
    end
  end

  def current_line
    @console_input[@current_line_index]
  end

  def increment_index!
    @current_line_index += 1
  end

  class FileTree
    attr_accessor :root

    def initialize
      @root = nil
    end

    def to_s
      root.to_s
    end

    def directories_under(size: 100_000)
      all_directories.select { |dir| dir.size < size }
    end

    def directories_over(size:)
      all_directories.select { |dir| dir.size >= size }
    end

    def all_directories
      root.dig_for_directories.flatten
    end
  end

  class Directory
    attr_accessor :children, :name, :size, :parent

    def initialize(name:, parent: nil)
      @name = name
      @parent = parent
      @children = []
    end

    def to_s
      content = parent.nil? ? "#{name} (dir)" : "#{parent&.name}: #{name} (dir)"
      children.each do |child|
        content << "\n#{child.to_s}"
      end
      content
    end

    def dig_for_directories
      directories.concat(directories.map(&:dig_for_directories))
    end

    def directories
      children.select { |child| child.is_a? CommandLineReader::Directory }
    end

    def size
      children.map(&:size).sum
    end

    def find_directory(directory_name)
      found_directory = directories.find { |child| child.name == directory_name }
      if found_directory != nil
        found_directory
      else
        found_directory = nil
        directories.each do |child|
          found_directory = child.find_directory(directory_name)
          break if found_directory != nil
        end
        found_directory
      end
    end
  end

  class ComputerFile
    attr_accessor :size, :name, :parent

    def initialize(size:, name:, parent:)
      @size = size.to_i
      @name = name
      @parent = parent
    end

    def to_s
      "#{parent.name}: #{name} (file, size=#{size})"
    end
  end
end

cr = CommandLineReader.new('data.txt')
puts cr.file_tree
p cr.sum_of_dirs_under_100k
p cr.smallest_directory_to_delete_to_free_enough_space.size
