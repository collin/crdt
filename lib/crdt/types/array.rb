class CRDT::Array < CRDT::Set
  undef add
  undef remove

  class Member < ::CRDT::Set
    def inspect
      "<#CRDT::Member #{atom.value} @ #{position.value}>"
    end

    def to_s
      inspect
    end

    def ==(other)
      return false unless other.is_a?(::CRDT::Array::Member)
      other.position == position && other.atom == atom
    end

    def <=>(other)
      position <=> other.position
    end

    def position
      atoms.detect{|atom| atom.is_a? ::CRDT::Array::Position }
    end

    def atom
      atoms.detect{|atom| !atom.is_a? ::CRDT::Array::Position }      
    end
  end

  class Position < ::CRDT::Atom
    attr_reader :value

    def ==(other)
      @value == other.value
    end

    def <=>(other)
      @value <=> other.value
    end

    def inspect
      "<#Position #{@value}"
    end
  end


  def slice!(start, length=1)
    while length > 0
      length -= 1
      _remove at(start).advance_clock
    end
  end

  def push(vector)
    _insert vector, last, nil
  end

  def pop
    return nil unless _last = last
    _remove _last.advance_clock
  end

  def shift
    return nil unless _first = first
    _remove _first.advance_clock
  end

  def unshift(vector)
    _insert vector, nil, first
  end

  def at(index)
    integrated[index]
  end

  def prev(atom)
  end

  def next(atom)
  end

  def index(vector)
    atoms.index(vector.atom)    
  end

  def _insert(vector, before, after)
    before = before ? before.atom.position.value : CRDT::Between::LOW
    after = after ? after.atom.position.value : CRDT::Between::HIGH

    sort = CRDT::Between.string(before, after)
    sort += CRDT::Between.rand(3)

    position = Position.new(sort)
    member = Member.new
    member.add vector.child(position)
    member.add vector
    _add vector.child(member)
    vector
  end

  def last
    integrated.last
  end

  def first
    integrated.first
  end

  def inspect
    atoms.to_s
  end

  def to_s
    atoms.to_s
  end

  def length
    integrated.length
  end

  def ==(other_atoms)
    if other_atoms.is_a?(::CRDT::Array)
      other_atoms = other_atoms.atoms
    end

    atoms == other_atoms
  end

  def integrated
    super.sort
  end

  protected
  def atoms
    integrated.map do |vector|
      vector.atom.atom
    end
  end
end