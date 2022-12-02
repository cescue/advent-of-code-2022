# frozen_string_literal: true

# A, B, C = Rock, paper, scissors for opponent
# X, Y, Z = Rock, paper, scissors for me

WIN_SCORE = 6
TIE_SCORE = 3

SHAPE_SCORES = {
  'X' => 1,
  'Y' => 2,
  'Z' => 3
}.freeze

MOVE_SCORES = {
  'A' => { 'X' => 3, 'Y' => 6 },
  'B' => { 'Y' => 3, 'Z' => 6 },
  'C' => { 'Z' => 3, 'X' => 6 }
}.freeze

total_score = 0

File.foreach('2_input.txt') do |line|
  opponent_plays = line[0]
  i_play = line[2]

  total_score += SHAPE_SCORES[i_play]

  next unless MOVE_SCORES[opponent_plays][i_play]

  total_score += MOVE_SCORES[opponent_plays][i_play]
end

puts total_score
