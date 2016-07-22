require_relative "stack.rb"

class MinMaxStackQueue
  def initialize
    @store_reverse = MyStack.new
    @store = MyStack.new
  end

  def enqueue(el)
    @store_reverse.push(el)
  end

  def dequeue
    num = @store_reverse.size
    num.times{@store.push(@store_reverse.pop)}
    @store.pop
    (num-1).times{@store_reverse.push(@store.pop)}
  end

  def max
    @store_reverse.max
  end

  def min
    @store_reverse.min
  end
end
