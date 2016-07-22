require_relative "minmaxstackqueue.rb"
require 'benchmark'

# tests

def performance_test(size, window, count)
  arr = Array.new(count) { random_arr(size) }

  Benchmark.benchmark(Benchmark::CAPTION, 15, Benchmark::FORMAT,
                        "Avg. Windowed:     ", "Avg. Optimized:    ") do |b|
    windowed = b.report("windowed_max_range:") { run_windowed_max_range(arr, window) }
    optimized = b.report("optimized_wmr:     ") { run_optimized_wmr(arr, window) }
    [windowed/count, optimized/count]
  end
end

def random_arr(n)
  Array.new(n) { rand(n) }
end

def run_windowed_max_range(arrays, window)
 arrays.each do |array|
   array_to_test = array.dup
   windowed_max_range(array, window)
 end
end

def run_optimized_wmr(arrays, window)
 arrays.each do |array|
   array_to_test = array.dup
   optimized_wmr(array, window)
 end
end

# methods

def windowed_max_range(arr, window)
  current_max_range = nil
  (0..arr.length - window).each do |i|
    temp = arr[i..i + window - 1]
    max = temp.max
    min = temp.min
    range = max - min
    current_max_range = range if current_max_range.nil? || range > current_max_range
  end
  current_max_range
end

def optimized_wmr(arr, window)
  current_max_range = nil
  (0..arr.length - window).each do |i|
    temp = MinMaxStackQueue.new
    (i..i + window - 1).each { |j| temp.enqueue(arr[j]) }
    max = temp.max
    min = temp.min
    range = max - min
    current_max_range = range if current_max_range.nil? || range > current_max_range
  end
  current_max_range
end

if __FILE__ == $PROGRAM_NAME
  puts "This is testing window size 10:"
  performance_test(100, 100, 1000)
  puts "This is testing window size 100:"
  performance_test(100, 10, 1000)
  puts "This is testing window size 1000:"
  performance_test(100, 1, 1000)
end
