{max} = Math
max = (list) -> Math.max.apply(null, list)
last = (list) -> list[ list.length ]

class CRDT.Set extends CRDT.Atom
  class @AtomSet
    constructor: ->
      @atoms = new Object

    add: (vector) ->
      ( @atoms[vector.atom] ||= [] ).push vector.clock

    at: (atom) -> @atoms[atom]

    without: (other) ->
      result = new Array
      for atom, clocks of @atoms
        otherAtom = other[atom] 
        maxClock = max(clocks)
        continue if otherAtom?[0] && max(otherAtom) > maxClock
        result.push CRDT.Vector.new(atom, maxClock)
      result

  constructor: ->
    @added = new AtomSet
    @removed = new AtomSet
    
  add: (vector) -> @_add(vector)
  remove: (vector) -> @_remove(vector)

  include: (atom) ->
    atom in @integrated()

  atoms: -> vector.atom for vector in @integrated()

  integrated: ->
    if @integrationCache
      @integrationCacheHit()
    else
      @integrationCacheMiss()

  integrationCacheHit: ->
    @integrationCache

  integrationCacheMiss: ->
    @integrationCache ||= @added.without(removed)

  dirty: -> @integrationCache = undefined

  willAppearRemoved: ({atom, clock}) ->
    addedAt = last @added.at(atom) || [-1]
    removedAt = last @removed.at(atom) || [-1]

    return false if addedAt >= clock
    return false if removedAt > clock
    return true

  willAppearAdded: ({atom, clock}) ->
    addedAt = last @added.at(atom) || [-1]
    removedAt = last @removed.at(atom) || [-1]

    return false if addedAt >= clock
    return false if removedAt >= clock
    return true

  _add: (vector, broadcast=true) ->
    @dirty()
    @added.add(vector)

  _remove: (vector, broadcast=true) ->
    @dirty()
    @removed.add(vector)