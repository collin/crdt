{detect, equals, sort, include, max, last, any} = CRDT

class CRDT.Hash extends CRDT.Set
  @::add = undefined
  @::remove = undefined

  class @Member extends CRDT.Set
    equals: (other) ->
      return false unless other.constructor is CRDT.Hash.Member
      key.equals other.key

    key: ->
      detect @atoms(), (atom) -> atom.constructor is CRDT.Hash.Key

    value: ->
      detect @atoms(), (atom) -> atom.constructor isnt CRDT.Hash.Key

  class @Key extends CRDT.Atom
    equals: (other) -> @value is other.value
    compareTo: (other) -> @value.compareTo(other.value)

  constructor: ->
    super
    @cache = new Object

  readPath: ([head, tail...]) ->
    if any tail
      @get(head).atom.value().readPath(tail)
    else if head?
      @get(head).atom.value().readValue()
    else
     this

  getAtom: ([head, tail...]) ->
    if any tail
      @get(head).atom.value().getAtom(tail)
    else if head?
      @get(head).atom.value()
    else
     this    

  set: (keyString, vector) ->
    @dirty()
    if detected = @get(keyString)
      detected.atom.remove vector.child( detected.atom.value() )
      detected.atom.add vector
    else
      key = new CRDT.Hash.Key(keyString)
      member = new CRDT.Hash.Member
      member.add vector.child(key)
      member.add vector
      @_add vector.child(member)

    @writeCache(keyString)
    vector

  get: (keyString) ->
    @cache?[keyString]

  delete: (keyString, clock) ->
    return null unless member = @get(keyString)
    out = @_remove member.advanceClock(clock)
    @writeCache(keyString)
    out

  equals: (otherAtoms) ->
    if otherAtoms.constructor is CRDT.Hash
      otherAtoms = otherAtoms.atoms()

    not detect @atoms(), (atom) -> not( include otherAtoms, atom )

  integrated: ->
    _cache = {}
    @added.atoms.forEach (atom, clocks) =>
      return if @removed.at(atom) && @removed.at(atom)[0] && max(@removed.at(atom)) > max(clocks)
      if _cache[atom.key()?.value] && last(_cache[atom.key().value]) < max(clocks)
        # I THINK SOMETHING HAS TO BE DONE HERE, WHO WINS?
        console.log 'NotHandle'
      else if _cache[atom.key()?.value] && last(_cache[atom.key().value]) < max(clocks)
        _cache[atom.key().value] = [atom, max(clocks)]
      else if not(_cache[atom.key()?.value])
        _cache[atom.key()?.value] = [atom, max(clocks)]
      
    new CRDT.Vector(atom, clock) for X, [atom, clock] of _cache

  atoms: ->
    item.atom for item in @integrated()

  writeCache: (keyString) ->
    key = new CRDT.Hash.Key(keyString)
    @cache[keyString] = detect @integrated(), (vector) ->
      vector.atom.key().equals(key)

  readValue: ->
    value = {}
    for atom in @atoms()
      value[atom.key().readValue()] = atom.value().readValue()
    value

