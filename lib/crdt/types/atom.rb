require 'observer'
require 'securerandom'
class CRDT::Atom
  include Observable

  attr_reader :value

  def initialize(value)
    @value = value
    @id = SecureRandom.hex()[0,10]
  end

  def ==(other)
    @value == other.value
  end

  def observe(other)
    other.add_observer(self, :synchronize)
  end

  def synchronize(operation, *args)
    send operation, *(args << false) # Don't rebroadcast
  end
end