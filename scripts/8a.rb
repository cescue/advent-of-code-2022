# frozen_string_literal: true

# Is it efficient? ... no.
# Is it _good_? ... no.
# Is it *cool*? ... you decide.

forest = File.readlines('8_input.txt')
             .map do |line|
               line.chomp.chars.map do |char|
                 {
                   size: char.to_i,
                   visible: false
                 }
               end
             end

row_size = forest.first.length
column_size = forest.length

%i[north_and_east south_and_west].each do |directions|
  # >;)
  forest.map!(&:reverse).reverse! if directions == :south_and_west

  tallest_trees_visible_from_y = forest.first.map { |tree| tree[:size] }

  (0..row_size - 1).each do |row_number|
    tallest_tree_visible_from_x = forest[row_number].first[:size]

    (0..column_size - 1).each do |col_number|
      forest[row_number][col_number][:visible] = true and next if row_number.zero? || col_number.zero?

      if forest[row_number][col_number][:size] > tallest_trees_visible_from_y[col_number]
        tallest_trees_visible_from_y[col_number] = forest[row_number][col_number][:size]
        forest[row_number][col_number][:visible] = true
      end

      if forest[row_number][col_number][:size] > tallest_tree_visible_from_x
        tallest_tree_visible_from_x = forest[row_number][col_number][:size]
        forest[row_number][col_number][:visible] = true
      end
    end
  end
end

puts forest.flatten.count { |x| x[:visible] }
