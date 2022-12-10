# frozen_string_literal: true

require 'set'

class Rope
  def initialize(knots = 2, x = 0, y = 0)
    @head = RopeKnot.new(x, y)

    @nodes_visited_by_tail = Set.new
  
    (knots - 1).times do |i|
      knot = RopeKnot.new(x, y)

      if i == knots - 2
        @tail = knot
        @nodes_visited_by_tail.add([x, y])
      end

      @head.attach(knot)
    end
  end

  def pull(direction, distance)
    distance.times do
      @head.pull(direction)

      @nodes_visited_by_tail.add([@tail.x, @tail.y])
    end
  end

  def total_nodes_visited_by_tail
    @nodes_visited_by_tail.count
  end
end

class RopeKnot
  attr_reader :x, :y, :next
  attr_writer :previous

  def initialize(x = 0, y = 0)
    @x, @y = x, y
  end

  def attach(rope_knot)
    if @next
      @next.attach(rope_knot)
      return
    end

    @next = rope_knot

    @next.previous = self
  end

  def pull(direction)
    case direction
    when 'U'
      @y -= 1
    when 'D'
      @y += 1
    when 'L'
      @x -= 1
    when 'R'
      @x += 1
    end

    @next&.adjust
  end

  def adjust
    δx = @previous.x - @x
    δy = @previous.y - @y

    if δx.abs > 1
      @x += δx.negative? ? -1 : 1

      if δy.abs > 0
        @y += δy.negative? ? -1 : 1
      end
    elsif δy.abs > 1
      @y += δy.negative? ? -1 : 1

      if δx.abs > 0
        @x += δx.negative? ? -1 : 1
      end
    end

    @next&.adjust 
  end
end

rope = Rope.new(2, 0, 0)

File.foreach('9_input.txt') do |line|

  direction, distance = line.chomp.split(' ')

  rope.pull(direction, distance.to_i)
end

puts rope.total_nodes_visited_by_tail
