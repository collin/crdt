require 'set'
class CRDT::Set < CRDT::Atom
  include Enumerable

  class AtomSet
    attr_reader :atoms
    
    def initialize
      @atoms = Hash.new  
    end

    def add(vector)
      ( @atoms[vector.atom] ||= [] ) << vector.clock
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
    if @integration_cache
      integration_cache_hit
    else
      integration_cache_miss
    end
  end

  def integration_cache_hit
    @integration_cache
  end

  def integration_cache_miss
    @integration_cache ||= @added - @removed
  end

  def dirty!
    @integration_cache = nil
  end

  def will_appear_added?(vector)
    atom = vector.atom
    clock = vector.clock
    added_at = (@added[atom] || [-1]).last
    removed_at = (@removed[atom] || [-1]).last

    # Was added more/as recently, will never appear as a change.
    return false if added_at >= clock
    # Was removed more recently, will never appear as a change.
    # If removed at same time, will appear to have been added
    return false if removed_at > clock
    # Otherwise any vector will appear to have been added
    return true
  end

  def will_appear_removed?(vector)
    atom = vector.atom
    clock = vector.clock
    added_at = (@added[atom] || [-1]).last
    removed_at = (@removed[atom] || [-1]).last

    # was added more recently, add wins
    return false if added_at >= clock
    return false if removed_at >= clock
    return true
  end

  # Only broadcasts the operation
  #   doesn't determine if/how this would appear
  #   to the outside world.
  def _add(vector, broadcast=true)
    dirty!
    
    # unless will_appear_added?(vector)
    # end

    @added.add(vector).tap do
      broadcast and changed and notify_observers :_add, vector # don't rebroadcast   
    end
  end  

  def _remove(vector, broadcast=true)
    dirty!
    
    # unless will_appear_removed?(vector)
    # end

    @removed.add(vector).tap do
      broadcast and changed and notify_observers :_remove, vector # don't rebroadcast
    end
  end
end