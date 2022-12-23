require 'set'
require 'pry'

module Assertions
  @disabled = false
  @logging = false

  class << self
    def included(base)
      raise <<~HERE
        You probably meant to include Assertions::Type, Assertions::Interface, or Assertions::Assertion
      HERE
    end

    def disable = @disabled = true
    def enable = @disabled = false
    def enabled? = !@disabled
    def disabled? = @disabled
    def logging? = @logging
  end

  module Disableable
    def disableable(*names)
      names.each do |name|
        old_method = self.instance_method(name)

        define_method(name) do |*args, &block|
          return args.first if Assertions.disabled?

          old_method.bind(self).call(*args, &block)
        end
        name
      end
    end
  end

  module Loggable
    def loggable(*names)
      names.each do |name|
        old_method = self.instance_method(name)

        define_method(name) do |*args, &block|
          puts "Checking #{args[1]} of #{args[2]} " if Assertions.logging?

          old_method.bind(self).call(*args, &block)
        end
        name
      end
    end
  end


  module Type
    extend Disableable
    extend Loggable

    def type?(klass, value) = value.is_a?(klass) && value

    alias_method :type, :type?

    def type!(klass, value)
      value.is_a?(klass) && value || raise("Expected: #{klass} given #{value.class}")
    end

    loggable :type?, :type!
    disableable :type?, :type!
  end

  module Interface
    extend Disableable

    disableable def interface?(methods, value)
      methods.to_set.subset?(value.methods.to_set) && value
    end

    alias_method :interface, :interface?

    disableable def interface!(methods, value) 
      interface?(methods, value) || raise("Expected #{value.class }#{value} to implement #{methods.join(', ')}")
    end
  end

  module Assertion
    extend Disableable

    disableable def assert?(&block) = !!block.call

    alias_method :assert, :assert?

    disableable def assert!(&block) = block.call || raise("Assertion failed")
  end


  module All
    def self.included(base)
      base.include(Assertions::Type)
      base.include(Assertions::Assertion)
      base.include(Assertions::Interface)
    end
  end
end


include Assertions::All

Assertions.enable


def foo(array)
  type Array, array
end

foo({})



# module Enumerable
#   def map2(&block)
#     map { |e| e.map(&block) }
#   end

#   def map3(&block)
#     map { |e| e.map {|f| f.map(&block)} }
#   end
# end



