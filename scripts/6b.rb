# frozen_string_literal: true

START_OF_MESSAGE_MARKER_LENGTH = 14

total_consumed_characters = START_OF_MESSAGE_MARKER_LENGTH

File.open('6_input.txt').each_char.each_cons(START_OF_MESSAGE_MARKER_LENGTH) do |sequence|
  break if sequence.uniq == sequence

  total_consumed_characters += 1
end

puts total_consumed_characters
