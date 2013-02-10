{detect, equals, sort} = CRDT

class CRDT.Array extends CRDT.Set
  @::add = undefined
  @::remove = undefined  

  class @Member extends CRDT.Set
    equals: (other) ->
      return false unless other.constructor is CRDT.Array.Member
      other.position.equals(@position) && other.atom.equals(@atom)

    compareTo: (other) ->
      @position.compareTo(other.position)

    position: ->
      detect @atoms(), (atom) -> atom.constructor is CRDT.Array.Position

    atom: ->
      detect @atoms(), (atom) -> atom.constructor isnt CRDT.Array.Position

  class @Position extends CRDT.Atom
    equals: (other) ->
      @value.equals other.value

    compareTo: (other) ->
      @value.compareTo(other.value)

  slice: (start=0, length=1) ->
    @_remove @at(start).advanceClock() while length--

  push: (vector) ->
    @_inser vector, @last(), null

  pop: ->
    return null unless _last = @last()
    @_remove _last.advanceClock()

  shift: ->
    return null unless _first = @first()
    @_remove _first.advanceClock()

  unshift: (vector) ->
    @_insert vector, nil, @first()

  prev: (atom) ->
  next: (atom) ->

  index: ({atom}) ->
    atoms.indexOf(atom)

  _insert: (vector, before, after) ->
    before = if before then before.atom.position().value else Between.low
    after = if after then after.atom.position().value else Between.high

    sort = Between.string(before, after)
    sort += Between.rand(3)

    position = new CRDT.Array.Position(sort)
    member = new CRDT.Array.Member
    member.add vector.child(position)
    member.add vector
    @_add vector.child(member)
    return vector

  last: -> @integrated()[ @length() ]
  first: -> @integrated()[0]

  length: -> @integrated().length

  equals: (otherAtoms) ->
    if otherAtoms.constructor is CRDT.Array
      otherAtoms = otherAtoms.atoms()

    equals @atoms(), otherAtoms

  integrated: ->
    sort super

  atoms: ->
    vector.atom.atom for vector in @integrated()


