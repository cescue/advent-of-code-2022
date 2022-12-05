# frozen_string_literal: true

stacks = nil
total_stacks = nil

starting_stacks_parsed = false

File.foreach('5_input.txt').with_index do |line, line_number|
  if line_number.zero?
    total_stacks = (line.chomp.length + 1) / 4
    stacks = Array.new(total_stacks).map { [] }
  end

  starting_stacks_parsed = true and next if line.chomp.empty?

  unless starting_stacks_parsed
    total_stacks.times do |i|
      next unless line[i * 4] == '['

      stacks[i].prepend(line[i * 4 + 1])
    end

    next
  end

  quantity, move_from, move_to = line.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i)

  quantity.times { stacks[move_to - 1] << stacks[move_from - 1].pop }
end

total_stacks.times { |i| print stacks[i].last }
puts
