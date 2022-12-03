# frozen_string_literal: true

WIN_SCORE = 6
TIE_SCORE = 3

ROCK, PAPER, SCISSORS = 'A', 'B', 'C'
WIN, LOSE, TIE = 'Z', 'X', 'Y'

SHAPE_SCORES = {
  ROCK => 1,
  PAPER => 2,
  SCISSORS => 3
}.freeze

MOVES = {
  ROCK => { WIN => PAPER, TIE => ROCK, LOSE => SCISSORS },
  PAPER => { WIN => SCISSORS, TIE => PAPER, LOSE => ROCK },
  SCISSORS => { WIN => ROCK, TIE => SCISSORS, LOSE => PAPER }
}.freeze

total_score = 0

File.foreach('2_input.txt') do |line|
  opponent_plays = line[0]
  game_outcome = line[2]

  i_play = MOVES[opponent_plays][game_outcome]

  total_score += SHAPE_SCORES[i_play]

  total_score += case game_outcome
                 when WIN
                   6
                 when TIE
                   3
                 else
                   0
                 end
end

puts total_score
