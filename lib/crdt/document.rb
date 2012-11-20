require "mutex_m"
class CRDT::Document < CRDT::Hash # INCEPTION!
  include Mutex_m

  def initialize(distributor)
    self.distributor = distributor
    @clock = 0
  end

  def beget(type, *args)
    atom = type.new(*args)
    atom.distributor = self.distributor
    @clock += 1
    self[key] = CRDT::Vector.new(atom, @clock)
    atom
  end
end
