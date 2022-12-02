# frozen_string_literal: true

most_calories = 0
current_elf_calories = 0

File.foreach('1_input.txt') do |line|
  current_elf_calories = 0 and next if line.chomp.empty?
    
  current_elf_calories += line.chomp.to_i

  most_calories = current_elf_calories if current_elf_calories > most_calories
end

puts most_calories