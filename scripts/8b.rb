# frozen_string_literal: true

forest = File.readlines('8_input.txt')
             .map do |line|
               line.chomp.chars.map do |char|
                 { size: char.to_i }
               end
             end

row_size = forest.first.length
column_size = forest.length
max_scenic_score = 0

(0..row_size - 1).each do |row_number|
  (0..column_size - 1).each do |col_number|
    tree = forest[row_number][col_number]

    viewing_distance_north = 0
    viewing_distance_south = 0
    viewing_distance_east = 0
    viewing_distance_west = 0

    unless col_number == column_size - 1
      (col_number + 1..column_size - 1).each do |i|
        viewing_distance_west += 1
        break if forest[row_number][i][:size] >= tree[:size]
      end
    end

    unless col_number.zero?
      (0..col_number - 1).reverse_each do |i|
        viewing_distance_east += 1
        break if forest[row_number][i][:size] >= tree[:size]
      end
    end

    unless row_number == row_size - 1
      (row_number + 1..row_size - 1).each do |i|
        viewing_distance_south += 1
        break if forest[i][col_number][:size] >= tree[:size]
      end
    end

    unless row_number.zero?
      (0..row_number - 1).reverse_each do |i|
        viewing_distance_north += 1
        break if forest[i][col_number][:size] >= tree[:size]
      end
    end

    scenic_score = viewing_distance_north * viewing_distance_south * viewing_distance_east * viewing_distance_west

    max_scenic_score = scenic_score if scenic_score > max_scenic_score
  end
end

puts max_scenic_score