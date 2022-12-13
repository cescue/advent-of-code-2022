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

packets = []

# Values hold the last known index of each divider packet.
divider_packets = {
  [[2]] => nil,
  [[6]] => nil
}

divider_packets.each_key do |packet|
  packets << packet
  divider_packets[packet] = packets.length - 1
end

File.foreach('13_input.txt').each_slice(3).with_index do |lines, i|
  packet1 = JSON.parse(lines[0])
  packet2 = JSON.parse(lines[1])

  if packets_in_correct_order?(packet1, packet2)
    packets << packet1
    packets << packet2
  else
    packets << packet2
    packets << packet1
  end
end

while true
  shuffled_packets = 0
  
  packets.each_cons(2).with_index do |pair, i|
    packet1 = pair[0]
    packet2 = pair[1]

    next if packets_in_correct_order?(packet1, packet2)

    packets[i], packets[i + 1] = packet2, packet1

    divider_packets[packets[i]] = i if divider_packets.keys.include?(packets[i])
    divider_packets[packets[i + 1]] = i + 1 if divider_packets.keys.include?(packets[i + 1])

    shuffled_packets += 1
  end

  break if shuffled_packets.zero?
end

puts divider_packets.values.map { |x| x + 1 }.inject(:*)