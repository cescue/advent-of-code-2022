# frozen_string_literal: true

MAX_DIRECTORY_SIZE = 100_000

last_command = nil
last_args = nil

directories = { '/' => {} }
current_directory = []

# Warning: Kind of dumb. The second argument is a hash, but I'm using it to store an integer.
# The only reason a hash is being used here is to simulate a pass-by-reference. this is allowing
# me to return the size of the parent directory, but also indirectly return the sum.
def directory_size(directory_tree, size_of_directories_smaller_than_max)
  total_size = 0

  directory_tree.each do |_, v|
    if v.is_a?(Integer)
      total_size += v
      next
    end

    subdirectory_size = directory_size(v, size_of_directories_smaller_than_max)

    size_of_directories_smaller_than_max[:size] += subdirectory_size if subdirectory_size < MAX_DIRECTORY_SIZE

    total_size += subdirectory_size
  end

  total_size
end

File.foreach('7_input.txt') do |line|
  if line[0] == '$'
    last_command, last_args = line.sub('$ ', '').chomp.split(' ')

    if last_command == 'cd'
      case last_args
      when '..'
        current_directory.pop
      when '/'
        current_directory = ['/']
      else
        current_directory << last_args
      end
    end

    next
  end

  case last_command
  when 'ls'
    size, name = line.chomp.split(' ')

    if size == 'dir'
      directories.dig(*current_directory)[name] ||= {}
      next
    end

    directories.dig(*current_directory)[name] = size.to_i
  end
end

directories_smaller_than_max = { size: 0 }

root_size = directory_size(directories, directories_smaller_than_max)

directories_smaller_than_max[:size] += root_size if root_size < MAX_DIRECTORY_SIZE

puts directories_smaller_than_max[:size]
