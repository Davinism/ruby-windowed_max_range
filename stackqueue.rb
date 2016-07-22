require_relative 'stack.rb'

class StackQueue

  def initialize
    @store_reverse = Stack.new
    @store = Stack.new
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

  def size
    @store_reverse.count
  end

  def empty?
    @store_reverse.empty?
  end

end
