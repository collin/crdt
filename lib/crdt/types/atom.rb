require 'observer'
class CRDT::Atom
  include Observable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def ==(other)
    @value = other.value
  end

  def observe(other)
    other.add_observer(self, :synchronize)
  end

  def synchronize(operation, *args)
    puts ["synchronize", self, operation, args].inspect
    send operation, *(args << false) # Don't rebroadcast
  end
end