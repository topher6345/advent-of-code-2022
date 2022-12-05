#! /usr/bin/env ruby

require 'pry'

class String
  def column(n) = self[(n  * 4)..((n * 4) + 2)][/\S+/]
end

input = <<-INPUT
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
INPUT




/(?<foo>\s{3})|(?<bar>\S{3})/ =~ "    [D]   "
bar

def main(input)
  state, instructions = input.split("\n\n")


  stacks = []

  state.each_line(chomp:true).take(3).each do |line|
    (0..2).each do |n|
      stacks[n] ||= []
      stacks[n].unshift(line.column(n)) if line.column(n)
    end
  end
  stacks.unshift nil


  instructions.each_line(chomp: true) do |line|
    /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/ =~ line

    count.to_i.times do 
      stacks[to.to_i].push stacks[from.to_i].pop
    end
  end

  stacks.shift
  stacks.map(&:last).map {|e| e[1]}.join
end

# input = DATA.read
result = main(input)
puts result

__END__
