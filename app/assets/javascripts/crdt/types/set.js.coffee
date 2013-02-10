{max} = Math
max = (list) -> Math.max.apply(null, list)
last = (list) -> list[ list.length ]

class CRDT.AtomSet
  constructor: ->
    @atoms = new CRDT.Map

  add: (vector) ->
    unless clocks = @at(vector.atom)
      clocks = []
      @atoms.set(vector.atom, clocks)

    clocks.push vector.clock

  at: (atom) -> @atoms.get(atom)

  without: (other) ->
    result = new Array
    @atoms.forEach (atom, clocks) ->
      otherAtom = other.at(atom)
      maxClock = max(clocks)
      unless otherAtom?[0] && max(otherAtom) > maxClock
        result.push new CRDT.Vector(atom, maxClock)
    result

class CRDT.Set extends CRDT.Atom
  constructor: ->
    @added = new CRDT.AtomSet
    @removed = new CRDT.AtomSet
    
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
    @integrationCache ||= @added.without(@removed)

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