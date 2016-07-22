class MyStack
  attr_reader :max, :min

  def initialize
    @store = []
    @max = nil
    @min = nil
  end

  def pop
    @store.pop
    @max = @store[-1][1]
    @min = @store[-1][2]
  end

  def push(el)
    @max = el if max.nil? || el > max
    @min = el if min.nil? || el < min
    @store.push([el, @max, @min])
  end

  def peek
    @store.last[0]
  end

  def size
    @store.count
  end

  def empty?
    @store.empty?
  end

end
