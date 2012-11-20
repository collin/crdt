class CRDT::Hash < CRDT::Set
  undef add
  undef remove

  class Member < ::CRDT::Set
    def inspect
      "<#CRDT::Member #{key.inspect} => #{value.inspect}>"
    end

    def to_s
      inspect
    end

    def ==(other)
      return false unless other.is_a?(::CRDT::Hash::Member)
      other.key == key
    end

    def key
      atoms.detect{|atom| atom.is_a? ::CRDT::Hash::Key }
    end

    def value
      atoms.detect{|atom| !atom.is_a? ::CRDT::Hash::Key }      
    end
  end

  class Key < ::CRDT::Atom
    attr_reader :value

    def ==(other)
      @value == other.value
    end

    def <=>(other)
      @value <=> other.value
    end

    def inspect
      "<#Key #{@value}"
    end
  end

  def []=(key_string, vector)
    key = Key.new(key_string)
    member = Member.new
    member.add vector.child(key)
    member.add vector
    _add vector.child(member)
    vector
  end

  def [](key_string)
    key = Key.new(key_string)
    return nil unless detected = integrated.detect do |vector|
      vector.atom.key == key
    end
    detected
  end

  def delete(key, clock=nil)
    return nil unless member = self[key]
    _remove member.advance_clock(clock)
  end

  def ==(other_atoms)
    if other_atoms.is_a?(::CRDT::Hash)
      other_atoms = other_atoms.atoms
    end

    !atoms.detect {|an_atom| !other_atoms.include?(an_atom) }
  end

  def integrated
    cache = {}
    @added.atoms.each do |atom, clocks|
      next if @removed[atom] && @removed[atom].first && @removed[atom].max > clocks.max
      if cache[atom.key.value] && cache[atom.key.value].last == clocks.max
        # I THINK SOMETHING HAS TO BE DONE HERE, WHO WINS?
      elsif cache[atom.key.value] && cache[atom.key.value].last < clocks.max
        cache[atom.key.value] = [atom, clocks.max] 
      elsif !cache[atom.key.value]
        cache[atom.key.value] = [atom, clocks.max] 
      end

    end
    cache.map do |_, (atom, clock)|
      CRDT::Vector.new(atom, clock)
    end
  end

  protected
  def atoms
    integrated.map(&:atom)
  end
end