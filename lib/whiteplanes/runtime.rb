module Whiteplanes
  class Runtime


    def initialize(source)
      code = source.each_char.map { |ch| ch }.select{ |ch| Runtime.symbols.include? ch }.join('')
      @commands = []
      pause(code) do |command, parameter|
        @commands << command.new(parameter, @commands.length)
      end
    end


    def run(context)
      @commands.select{ |command| command.class == Register }.each do |command|
        command.process(context)
      end

      @commands
      while context.counter < @commands.length
        command = @commands[context.counter]
        if command.class == Register
          context.counter += 1
          next
        end
        command.process(context)
        context.counter += 1
      end
    end

    private

    def pause(code)
      cursor = 0
      while cursor < code.length do
        now = code[cursor..code.length]
        Runtime.commands.each do |command|
          pattern = /\A(#{command.token})#{command.parameter ? '([\s]*)' : '()'}/
          match = pattern.match(now)
          next if match == nil

          counter = command.step
          param = nil
          if command.parameter
            param, step = parameter match[2]
            counter += step
          end
          cursor += counter
          yield command, param if block_given?
          break
        end
      end
    end


    def parameter(code)
      res = ''
      code.each_char do |c|
        if c == " "
          res += '0'
        elsif c == "\t"
          res += '1'
        else
          return res, res.length + 1
        end
      end
    end


    class << self
      def symbols
        [" ","\t","\n"]
      end

      def commands
        [Push, Copy, Slide, Duplicate, Swap, Discard, Add, Sub, Mul, Div, Mod, Store, Retrieve,
         Register, Call, Jump, Equal, Less, Return, End, Cout, Iout, Cin, Iin]
      end
    end
  end
end