# frozen_string_literal: true

DISK_SIZE = 70_000_000
UPDATE_SIZE = 30_000_000

last_command = nil
last_args = nil

directories = { '/' => {} }
current_directory = []

def directory_size(directory_tree)
  total_size = 0

  directory_tree.each do |_, v|
    if v.is_a?(Integer)
      total_size += v
      next
    end

    subdirectory_size = directory_size(v)

    total_size += subdirectory_size
  end

  total_size
end

# Warning: Kind of dumb. Same thing as 7a. The _real_ return value is smallest_directory.
def size_of_smallest_directory(directory_tree, min_size, smallest_directory)
  total_size = 0

  directory_tree.each do |_, v|
    if v.is_a?(Integer)
      total_size += v
      next
    end

    subdirectory_size = size_of_smallest_directory(v, min_size, smallest_directory)

    if subdirectory_size > min_size &&
       (smallest_directory[:size].nil? || subdirectory_size < smallest_directory[:size])
      
      smallest_directory[:size] = subdirectory_size
    end

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

root_size = directory_size(directories)

required_space = -1 * (DISK_SIZE - UPDATE_SIZE - root_size)

smallest_directory_greater_than_min = { size: nil }

size_of_smallest_directory(directories, required_space, smallest_directory_greater_than_min)

puts smallest_directory_greater_than_min[:size]
