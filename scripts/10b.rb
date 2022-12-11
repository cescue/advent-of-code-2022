# frozen_string_literal: true

class ElvenCommunicationSystem
  attr_reader :cycle, :x_register

  CYCLES_REQUIRED = { 'addx' => 2, 'noop' => 1 }.freeze

  def initialize
    @cycle = 1
    @x_register = 1
    @instructions = []
  end

  def add_instruction(command, argument)
    @instructions << {
      command: command,
      argument: argument,
      remaining_cycles: CYCLES_REQUIRED[command]
    }
  end

  def run_cycle
    draw

    execute_next_instruction

    @cycle += 1
  end

  def pending_instructions?
    @instructions.length > 0
  end


  private

  def execute_next_instruction
    @instructions.first[:remaining_cycles] -= 1

    return if @instructions.first[:remaining_cycles] > 0

    command, argument = @instructions.first.values_at(:command, :argument)

    case command
    when 'addx'
      @x_register += argument
    end

    @instructions.shift
  end

  def draw
    cursor_position = (@cycle - 1) % 40

    output = (@x_register - cursor_position).abs <= 1 ? '#' : '.'

    print output

    puts if cursor_position == 39
  end
end

communicator = ElvenCommunicationSystem.new

signal_strength_sum = 0

File.foreach('10_input.txt') do |line|
  command, argument = line.chomp.split(' ')

  communicator.add_instruction(command, argument.to_i)

  communicator.run_cycle
end

while communicator.pending_instructions?
  communicator.run_cycle
end

