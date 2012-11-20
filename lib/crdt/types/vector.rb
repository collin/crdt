class CRDT::Vector
  attr_reader :atom, :clock
  def initialize(atom, clock)
    @atom, @clock = atom, clock
  end

  def child(child_atom)
    CRDT::Vector.new(child_atom, @clock)
  end

  def advance_clock(clock=nil)
    CRDT::Vector.new(@atom, clock || @clock + 1)
  end

  def inspect
    "<#CRDT::Vector #{atom.inspect} @ #{clock}>"
  end

  def ==(other)
    return false unless other.is_a?(::CRDT::Vector)
    atom == other.atom && clock == other.clock
  end

  def <=>(other)
    atom <=> other.atom
  end
end