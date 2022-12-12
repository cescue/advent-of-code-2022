# frozen_string_literal: true

class Hill
  attr_reader :sigil, :elevation, :accessible_hills

  def initialize(height)
    @accessible_hills = []

    @sigil = height

    height = case height
             when 'S'
               'a'
             when 'E'
               'z'
             else
               height
             end

    @elevation = %w[S E].include?(height) ? height : height.ord
  end

  def add_path_to_hill_if_accessible(hill)
    return unless hill.elevation <= @elevation + 1

    @accessible_hills << hill
  end

  def shortest_distance_to(heightmap, destination)
    distance_to = { self => 0 }
    unvisited_hills = []

    heightmap.flatten.each do |v|
      distance_to[v] = Float::INFINITY unless v == self

      unvisited_hills << v
    end

    until unvisited_hills.empty?
      unvisited_hills.sort_by! { |x| distance_to[x] }

      closest_hill = unvisited_hills.shift

      closest_hill.accessible_hills.each do |neighboring_hill|
        alternate_path = distance_to[closest_hill] + 1

        distance_to[neighboring_hill] = alternate_path if alternate_path < distance_to[neighboring_hill]
      end
    end

    distance_to[destination]
  end
end

heightmap = File.readlines('12_input.txt')
                .map { |line| line.chomp.chars.map { |char| Hill.new(char) } }

start_point = nil
end_point = nil

heightmap.each_with_index do |hills, y|
  hills.each_with_index do |hill, x|
    start_point = hill if hill.sigil == 'S'
    end_point = hill if hill.sigil == 'E'

    hill.add_path_to_hill_if_accessible(heightmap[y - 1][x]) if y > 0
    hill.add_path_to_hill_if_accessible(heightmap[y + 1][x]) if y < heightmap.length - 1
    hill.add_path_to_hill_if_accessible(heightmap[y][x - 1]) if x > 0
    hill.add_path_to_hill_if_accessible(heightmap[y][x + 1]) if x < hills.length - 1
  end
end

puts start_point.shortest_distance_to(heightmap, end_point)
