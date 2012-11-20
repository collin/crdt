require 'set'
class CRDT::Set < CRDT::Atom
  include Enumerable

  class AtomSet
    attr_reader :atoms
    
    def initialize
      @atoms = Hash.new  
    end

    def add(vector)
      # puts ["add vector", self, vector.atom, vector.atom.hash, @atoms.assoc(vector.atom)].inspect
      unless set = @atoms[vector.atom]
        set = @atoms[vector.atom] = []
      end
      set << vector.clock
    end

    def [](atom)
      @atoms[atom]
    end

    def -(other)
      result = []
      @atoms.each do |atom, clocks|
        next if other[atom] && other[atom].first && other[atom].max > clocks.max
        result << CRDT::Vector.new(atom, clocks.max)
      end
      result
    end

    def table
      Hirb::Console.table @atoms
    end
  end

  def initialize
    @added = AtomSet.new
    @removed = AtomSet.new
  end

  def table
    require "hirb"
    puts "ADDED"
    @added.table
    puts "REMOVED"
    @removed.table
  end

  def add(vector); _add(vector) end
  def remove(vector); _remove(vector) end

  def include?(atom)
    integrated.include?(atom)
  end

  def each(&block)
    integrated.each(&block)
  end

  def atoms
    integrated.map(&:atom)
  end

  private
  def integrated
    @added - @removed
  end

  def _add(vector, broadcast=true)
    @added.add(vector).tap do
      broadcast and changed and notify_observers :_add, vector # don't rebroadcast   
    end
  end  

  def _remove(vector, broadcast=true)
    @removed.add(vector).tap do
      broadcast and changed and notify_observers :_remove, vector # don't rebroadcast
    end
  end
end