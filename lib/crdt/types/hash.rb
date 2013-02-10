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

  def initialize
    super
    @cache = {}
  end

  def []=(key_string, vector)
    if detected = self[key_string]
      detected.atom.remove vector.child(detected.atom.value)
      detected.atom.add vector
    else
      key = Key.new(key_string)
      member = Member.new
      member.add vector.child(key)
      member.add vector
      _add vector.child(member)
      vector
    end

    cache(key_string)

    vector
  end

  def [](key_string)
    @cache[key_string]
  end

  def delete(key, clock=nil)
    return nil unless member = self[key]
    out = _remove member.advance_clock(clock)
    cache(key)
    out
  end

  def cache(key_string)
    key = Key.new(key_string)
    @cache[key_string] = integrated.detect do |vector|
      vector.atom.key == key
    end
  end

  def ==(other_atoms)
    if other_atoms.is_a?(::CRDT::Hash)
      other_atoms = other_atoms.atoms
    end

    !atoms.detect {|an_atom| !other_atoms.include?(an_atom) }
  end

  def integrated
    _cache = {}
    @added.atoms.each do |atom, clocks|
      next if @removed[atom] && @removed[atom].first && @removed[atom].max > clocks.max
      if _cache[atom.key.value] && _cache[atom.key.value].last == clocks.max
        # I THINK SOMETHING HAS TO BE DONE HERE, WHO WINS?
        puts :NotHandle
      elsif _cache[atom.key.value] && _cache[atom.key.value].last < clocks.max
        _cache[atom.key.value] = [atom, clocks.max] 
      elsif !_cache[atom.key.value]
        _cache[atom.key.value] = [atom, clocks.max] 
      end
    end
    _cache.map do |_, (atom, clock)|
      CRDT::Vector.new(atom, clock)
    end
  end

  protected
  def atoms
    integrated.map(&:atom)
  end
end