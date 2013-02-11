class CRDT.Atom
  constructor: (@value, @id) ->
  
  equals: (other) ->
    @value is other.value

  readValue: -> @value
