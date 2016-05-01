require 'spec_helper'

Context = Struct.new(:stack, :heap, :labels, :callstack, :counter) do
  def input(name)
    return name == :cin ? 'H' : 72
  end

  def output(value)
    print value
  end
end


describe Whiteplanes do
  it "Execute 'hello_world'" do
    context = Context.new([], {}, {}, [], 0)
    File.open('./spec/whiteplanes/etc/hello_world.ws') do |code|
      interpreter = Whiteplanes::Runtime.new(code.read)
      expect { interpreter.run(context) }.to output("Hello World\n").to_stdout
    end
  end

  it "Execute 'heap_control'" do
    context = Context.new([], {}, {}, [], 0)
    File.open('./spec/whiteplanes/etc/heap_control.ws') do |code|
      interpreter = Whiteplanes::Runtime.new(code.read)
      expect { interpreter.run(context) }.to output("Hello World\n").to_stdout
    end
  end

  it "Execute 'flow_control'" do
    context = Context.new([], {}, {}, [], 0)
    File.open('./spec/whiteplanes/etc/flow_control.ws') do |code|
      interpreter = Whiteplanes::Runtime.new(code.read)
      expect { interpreter.run(context) }.to output("52").to_stdout
    end
  end

  it "Execute 'count'" do
    context = Context.new([], {}, {}, [], 0)
    File.open('./spec/whiteplanes/etc/count.ws') do |code|
      interpreter = Whiteplanes::Runtime.new(code.read)
      expect { interpreter.run(context) }.to output("1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n").to_stdout
    end
  end

  it "Execute 'input'" do
    context = Context.new([], {}, {}, [], 0)
    File.open('./spec/whiteplanes/etc/input.ws') do |code|
      interpreter = Whiteplanes::Runtime.new(code.read)
      expect { interpreter.run(context) }.to output("H72").to_stdout
    end
  end
end