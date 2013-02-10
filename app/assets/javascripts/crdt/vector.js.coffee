class CRDT.Vector
  constructor: (@atom, @clock) ->

  child: (atom) ->
    new CRDT.Vector(atom, @clock)

  advanceClock: (clock=nil) ->
    new CRDT.Vector(@atom, clock || @clock + 1)

  equals: (other) ->
    return false unless other.constructor is CRDT.Vector
    @atom.equals(other) and @clock is other.clock
  
  compareTo: ({atom}) ->
    @atom.compareTo(atom)
