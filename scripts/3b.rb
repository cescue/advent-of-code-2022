# frozen_string_literal: true

ITEM_PRIORITIES = Hash['abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.chars.zip((1..52))]

found_items = {}

ITEM_PRIORITIES.each_key { |item| found_items[item] = { 0 => false, 1 => false, 2 => false } }

sum_of_badge_priorities = 0

File.foreach('3_input.txt').each_slice(3) do |elf_inventories|
  3.times do |elf|
    elf_inventories[elf].chomp.chars.each do |item|
      found_items[item][elf] = true
    end
  end

  ITEM_PRIORITIES.each_key do |item|
    if found_items[item][0] && found_items[item][1] && found_items[item][2]
      sum_of_badge_priorities += ITEM_PRIORITIES[item]
      break
    end
  end

  found_items.each_value { |sum_of_priorities| sum_of_priorities.transform_values! { |_x| false } }
end

puts sum_of_badge_priorities
