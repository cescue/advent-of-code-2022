# frozen_string_literal: true

require 'yaml'

class Item
  attr_reader :worry_level

  def initialize(worry_level)
    @worry_level = worry_level
  end

  def perform_operation(operation_string)
    operation_string = operation_string.gsub('new = ', '')

    old = @worry_level

    @worry_level = eval(operation_string)
  end

  def decay_worry(rate_of_decay)
    @worry_level %= rate_of_decay
  end
end

class Monkey
  attr_reader :test_value, :operation, :total_inspections
  attr_writer :worry_decay_rate

  def initialize(items, operation, test)
    @items = items
    @operation = operation
    @total_inspections = 0

    @test_value = test['condition'].split(' ').last.to_i
    @test_pass = test['If true'].split(' ').last.to_i
    @test_fail = test['If false'].split(' ').last.to_i
  end

  def operate
    @items.first.perform_operation(@operation)
  end

  def get_bored
    @items.first.decay_worry(@worry_decay_rate)
  end

  def test
    return @test_pass if (@items.first.worry_level % @test_value).zero?

    @test_fail
  end

  def assign_item(item)
    @items << item
  end

  def inspect_item
    @total_inspections += 1

    @items.first.worry_level
  end

  def throw_item(recipient)
    recipient.assign_item(@items.shift)
  end

  def has_items?
    !@items.empty?
  end
end

monkeys = []

input = File.read('11_input.txt').gsub('Test:', "Test:\n    condition:")

YAML.load(input).each do |monkey_name, attributes|
  monkey_index = monkey_name.split(' ').last.to_i

  monkeys[monkey_index] = Monkey.new(
    attributes['Starting items'].to_s.split(', ').map { |i| Item.new(i.to_i) },
    attributes['Operation'],
    attributes['Test']
  )
end

lcm_of_monkey_modulos = monkeys.map(&:test_value).inject(&:lcm)

monkeys.each { |monkey| monkey.worry_decay_rate = lcm_of_monkey_modulos }

10_000.times do
  monkeys.each_with_index do |monkey, i|
    while monkey.has_items?
      monkey.inspect_item

      monkey.operate

      monkey.get_bored

      pass_to = monkey.test

      monkey.throw_item(monkeys[pass_to])
    end
  end
end

puts monkeys.map(&:total_inspections).sort.sort[-2..].inject(:*)
