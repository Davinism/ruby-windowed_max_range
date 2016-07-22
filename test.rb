require 'benchmark'

class MyStack
  def initialize(store = [])
    @store = store
  end

  def empty?
    @store.empty?
  end

  def peek
    @store.last
  end

  def pop
    @store.pop
  end

  def push(val)
    @store.push(val)
  end

  def size
    @store.size
  end
end

class MinMaxStack
  def initialize
    @store = MyStack.new
  end

  def empty?
    @store.empty?
  end

  def min
    @store.peek[:min] unless empty?
  end

  def max
    @store.peek[:max] unless empty?
  end

  def peek
    @store.peek[:value] unless empty?
  end

  def pop
    @store.pop[:value] unless empty?
  end

  def push(val)
    # By using a little extra memory, we can get the max simply by peeking,
    # which is O(1).
    @store.push({
      max: new_max(val),
      min: new_min(val),
      value: val
    })
  end

  def size
    @store.size
  end

  private

  def new_max(val)
    empty? ? val : [max, val].max
  end

  def new_min(val)
    empty? ? val : [min, val].min
  end
end

class MinMaxStackQueue
  def initialize
    @in_stack = MinMaxStack.new
    @out_stack = MinMaxStack.new
  end

  def dequeue
    queueify if @out_stack.empty?
    @out_stack.pop
  end

  def enqueue(val)
    @in_stack.push(val)
  end

  def empty?
    @in_stack.empty? && @out_stack.empty?
  end

  def max
    # At most two operations; O(1)
    maxes = []
    maxes << @in_stack.max unless @in_stack.empty?
    maxes << @out_stack.max unless @out_stack.empty?
    maxes.max
  end

  def min
    mins = []
    mins << @in_stack.min unless @in_stack.empty?
    mins << @out_stack.min unless @out_stack.empty?
    mins.min
  end

  def size
    @in_stack.size + @out_stack.size
  end

  private
  def queueify
    @out_stack.push(@in_stack.pop) until @in_stack.empty?
  end
end


def max_windowed_range(array, window_size)
  queue = MinMaxStackQueue.new
  best_range = nil

  array.each_with_index do |el, i|
    queue.enqueue(el)
    queue.dequeue if queue.size > window_size

    if queue.size == window_size
      current_range = queue.max - queue.min
      best_range = current_range if !best_range || current_range > best_range
    end
  end

  best_range
end

def performance_test(size, window, count)
  arr = Array.new(count) { random_arr(size) }

  Benchmark.benchmark(Benchmark::CAPTION, 15, Benchmark::FORMAT,
                        "Avg. Windowed:     ") do |b|
    windowed = b.report("max_windowed_range:") { run_max_windowed_range(arr, window) }
    [windowed/count]
  end
end

def random_arr(n)
  Array.new(n) { rand(n) }
end

def run_max_windowed_range(arrays, window)
 arrays.each do |array|
   array_to_test = array.dup
   max_windowed_range(array, window)
 end
end

def run_optimized_wmr(arrays, window)
 arrays.each do |array|
   array_to_test = array.dup
   optimized_wmr(array, window)
 end
end

if __FILE__ == $PROGRAM_NAME
  puts "This is testing window size 10:"
  performance_test(100, 100, 1000)
  puts "This is testing window size 100:"
  performance_test(100, 10, 1000)
  puts "This is testing window size 1000:"
  performance_test(100, 1, 1000)
end
