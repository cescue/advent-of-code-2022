# frozen_string_literal: true

most_calories = [0, 0, 0]

current_elf_calories = 0

File.foreach('1_input.txt') do |line|
  if line.chomp.empty?
    most_calories << current_elf_calories

    current_elf_calories = 0
    most_calories = most_calories.sort![1..3]
    next
  end

  current_elf_calories += line.chomp.to_i
end

most_calories << current_elf_calories
most_calories = most_calories.sort![1..3]

puts most_calories.inject(&:+)
