# frozen_string_literal: true

total_overlapping_ranges = 0

File.foreach('4_input.txt') do |line|
  range_1_start, range_1_end, range_2_start, range_2_end = line.split(',')
                                                               .map { |range| range.split('-') }
                                                               .flatten
                                                               .map(&:to_i)

  if range_1_start <= range_2_start && range_2_start <= range_1_end ||
     range_2_start <= range_1_start && range_1_start <= range_2_end ||
     range_1_start >= range_2_start && range_1_end <= range_2_end ||
     range_2_start >= range_1_start && range_2_end <= range_1_end
    total_overlapping_ranges += 1
  end
end

puts total_overlapping_ranges
