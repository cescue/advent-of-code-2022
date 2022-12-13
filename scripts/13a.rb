# frozen_string_literal: true

require 'json'

def packets_in_correct_order?(packet1, packet2)
  iterations = [packet1.length, packet2.length].max

  iterations.times do |i|
    return true if packet1[i].nil? && packet2[i]
    return false if packet1[i] && packet2[i].nil?

    if packet1[i].is_a?(Integer) && packet2[i].is_a?(Integer)
      return false if packet1[i] > packet2[i]
      return true if packet1[i] < packet2[i]
    end

    correct_order = if packet1[i].is_a?(Array) && packet2[i].is_a?(Array)
                      packets_in_correct_order?(packet1[i], packet2[i])
                    elsif packet1[i].is_a?(Array) && packet2[i].is_a?(Integer)
                      packets_in_correct_order?(packet1[i], [packet2[i]])
                    elsif packet1[i].is_a?(Integer) && packet2[i].is_a?(Array)
                      packets_in_correct_order?([packet1[i]], packet2[i])
                    end

    return correct_order unless correct_order.nil?
  end

  nil
end

indexes_of_correctly_ordered_packets = []

File.foreach('13_input.txt').each_slice(3).with_index do |lines, i|
  packet1 = JSON.parse(lines[0])
  packet2 = JSON.parse(lines[1])

  indexes_of_correctly_ordered_packets << (i + 1) if packets_in_correct_order?(packet1, packet2)
end

puts indexes_of_correctly_ordered_packets.inject(:+)
