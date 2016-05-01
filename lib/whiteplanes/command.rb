module Whiteplanes
  Token = Struct.new(:token, :step, :parameter)
  @tokens = {
      push:       Token.new('  ',       2, true),
      copy:       Token.new(' \t ',     3, true),
      slide:      Token.new(' \t\n',    3, true),
      duplicate:  Token.new(' \n ',     3, false),
      swap:       Token.new(' \n\t',    3, false),
      discard:    Token.new(' \n\n',    3, false),
      add:        Token.new('\t   ',    4, false),
      sub:        Token.new('\t  \t',   4, false),
      mul:        Token.new('\t  \n',   4, false),
      div:        Token.new('\t \t ',   4, false),
      mod:        Token.new('\t \t\t',  4, false),
      store:      Token.new('\t\t ',    3, false),
      retrieve:   Token.new('\t\t\t',   3, false),
      register:   Token.new('\n  ',     3, true),
      call:       Token.new('\n \t',    3, true),
      jump:       Token.new('\n \n',    3, true),
      equal:      Token.new('\n\t ',    3, true),
      less:       Token.new('\n\t\t',   3, true),
      return:     Token.new('\n\t\n',   3, false),
      end:        Token.new('\n\n\n',   3, false),
      cout:       Token.new('\t\n  ',   4, false),
      iout:       Token.new('\t\n \t',  4, false),
      cin:        Token.new('\t\n\t ',  4, false),
      iin:        Token.new('\t\n\t\t', 4, false)
  }

  class Push
    def process(context)
      context.stack << @param.to_i(2)
    end
  end

  class Copy
    def process(context)
      context.stack << context.stack[@param.to_i(2)]
    end
  end

  class Slide
    def process(context)
      value = context.stack.pop
      @param.to_i(2).times do
        context.stack.pop
      end
      context.stack << value
    end
  end

  class Duplicate
    def process(context)
      context.stack << context.stack.last
    end
  end

  class Swap
    def process(context)
      context.stack[-1], context.stack[-2] = context.stack[-2], context.stack[-1]
    end
  end

  class Discard
    def process(context)
      context.stack.pop
    end
  end

  class Add
    def process(context)
      lhs, rhs = context.stack.pop, context.stack.pop
      context.stack << lhs + rhs
    end
  end

  class Sub
    def process(context)
      lhs, rhs = context.stack.pop, context.stack.pop
      context.stack << lhs - rhs
    end
  end

  class Mul
    def process(context)
      lhs, rhs = context.stack.pop, context.stack.pop
      context.stack << lhs * rhs
    end
  end

  class Div
    def process(context)
      lhs, rhs = context.stack.pop, context.stack.pop
      context.stack << lhs / rhs
    end
  end

  class Mod
    def process(context)
      lhs, rhs = context.stack.pop, context.stack.pop
      context.stack << lhs % rhs
    end
  end

  class Store
    def process(context)
      value = context.stack.pop
      address = context.stack.pop
      context.heap[address] = value
    end
  end

  class Retrieve
    def process(context)
      address = context.stack.pop
      context.stack << context.heap[address]
    end
  end

  class Register
    def process(context)
      context.labels[@param] = @location
    end
  end

  class Call
    def process(context)
      context.callstack << @location
      context.counter = context.labels[@param]
    end
  end

  class Jump
    def process(context)
      context.counter = context.labels[@param]
    end
  end

  class Equal
    def process(context)
      value = context.stack.pop
      context.counter = context.labels[@param] if value == 0
    end
  end

  class Less
    def process(context)
      value = context.stack.pop
      context.counter = context.labels[@param] if value != 0
    end
  end

  class Return
    def process(context)
      context.counter = context.callstack.pop
    end
  end

  class End
    def process(context)
      context.counter = (2**(0.size * 8 -2) -1) - 1
    end
  end

  class Cout
    def process(context)
      value = context.stack.pop
      context.output(value.chr)
    end
  end

  class Iout
    def process(context)
      value = context.stack.pop
      context.output(value)
    end
  end

  class Cin
    def process(context)
      address = context.stack.pop
      value = context.input(:cin)
      context.heap[address] = value.ord
    end
  end

  class Iin
    def process(context)
      address = context.stack.pop
      value = context.input(:iin)
      context.heap[address] = value
    end
  end

  # Set property.
  @tokens.keys.each do |name|
    command = const_get name.capitalize

    token = @tokens[name.to_sym]
    command.class_eval do
      instance_variable_set("@token", token.token)
      instance_variable_set("@step", token.step)
      instance_variable_set("@parameter", token.parameter)

      def initialize(parameter, location)
        instance_variable_set("@param", parameter)
        instance_variable_set("@location", location)
      end

      def self.token
        instance_variable_get("@token")
      end

      def self.step
        instance_variable_get("@step")
      end

      def self.parameter
        instance_variable_get("@parameter")
      end
    end
  end
end