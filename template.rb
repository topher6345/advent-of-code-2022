#! /usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

input = <<~INPUT
INPUT

def main(input)
  input
end

input = DATA.read
result = main(input)
puts result

__END__
