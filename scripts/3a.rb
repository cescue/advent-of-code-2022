# frozen_string_literal: true

ITEM_PRIORITIES = Hash['abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.chars.zip((1..52))]

sum_of_duplicate_priorities = 0

File.foreach('3_input.txt') do |line|
  line.chomp!

  compartment_1_items = line[0..line.length / 2 - 1]
  compartment_2_items = line[compartment_1_items.length..line.length - 1]

  compartment_1_items.chars.each do |char|
    if compartment_2_items.include?(char)
      sum_of_duplicate_priorities += ITEM_PRIORITIES[char]
      break
    end
  end
end

puts sum_of_duplicate_priorities
